//
//  RedditService.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import Foundation
import UIKit
import RxSwift

protocol RedditServiceProtocol {
    func getTopEntries(afterPagination: String?) -> Observable<RedditResponse>
}

class RedditService: RedditServiceProtocol {
    private init() { }
    
    static let shared = RedditService()
    
    func getTopEntries(afterPagination: String?) -> Observable<RedditResponse> {
        return Observable.create { observer in
            self.getTopEntries(after: afterPagination, success: {
                observer.onNext($0)
                observer.onCompleted()
            },
            failure: { observer.onError($0) })
            return Disposables.create()
        }
    }
    
    private func getTopEntries(after: String?, success: @escaping (RedditResponse) -> Void, failure: ((_ error: Error) -> Void)?) {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlString = "https://oauth.reddit.com/r/popular/top.json"
        
        var items = [URLQueryItem]()
        var urlComponents = URLComponents(string: urlString)
        
        if let after = after {
            let param = ["after": after]
            for (key,value) in param {
                items.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = items
        }
        
        guard let url = urlComponents?.url else {
            failure?(RedditServerError(message: "The url is not an URL: \(urlString)"))
            return
        }
                
        var request = URLRequest(url: url)
        let token = "Bearer \(NetworkConfigs.sharedInstance.accessToken)"
        
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(RedditServerError(message: "Cant connect to the server"))
                return
            }
            
            switch httpResponse.statusCode {
            case 401:
                self.requestToken(success: {
                    self.getTopEntries(after: after, success: success, failure: failure)
                }, failure: failure)
                
            case 200:
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let jsonDic = json as? [String: Any],
                      let jsonDicData = jsonDic["data"] as? [String: Any],
                      let jsonModel = try? JSONSerialization.data(withJSONObject: jsonDicData),
                      let redditEntries = try? JSONDecoder().decode(RedditResponse.self, from: jsonModel) else {
                    failure?(RedditServerError(message: "Cant deserialize response from server"))
                    return
                }
                success(redditEntries)
            default:
                failure?(RedditServerError(message: "Cant connect to the server"))
            }
        })
        task.resume()
    }

    private func requestToken(success: @escaping () -> Void, failure: ((_ error: Error) -> Void)?) {
        let ACCESS_TOKEN_URL = "https://www.reddit.com/api/v1/access_token"
        let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"

        let timeout = 15
        let uncodedClientIDAndPassword = "\(NetworkConfigs.sharedInstance.clientID):"
        guard let uncodedClientIDAndPasswordData = uncodedClientIDAndPassword.data(using: .utf8) else {
            failure?(RedditServerError(message: "Unexpected Error"))
            return
        }
        let encodedClientIDAndPassword = uncodedClientIDAndPasswordData.base64EncodedString(options: .lineLength64Characters)
        
        let authStr = "Basic \(encodedClientIDAndPassword)"
        guard let serviceUrl = URL(string: ACCESS_TOKEN_URL) else {
            failure?(RedditServerError(message: "Unexpected Error"))
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(authStr, forHTTPHeaderField: "Authorization")
        
        let param = "grant_type=\(GRANT_TYPE)&device_id=\(DEVICE_ID)"
        let data = param.data(using: .utf8)
        request.httpBody = data

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        config.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []),
                  let jsonDic = json as? [String: Any],
                  let accessToken = jsonDic["access_token"] as? String else {
                failure?(RedditServerError(message: "Cant deserialize response from server"))
                return
            }
            NetworkConfigs.sharedInstance.accessToken = accessToken
            success()
            return
        }.resume()

    }
}

struct RedditServerError: Error {
    let message: String
}

