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
    func getTopEntries() -> Observable<[ResultTopEntries]>
    func requestToken() -> Observable<String>
}

class RedditService: RedditServiceProtocol {
    private init() { }
    
    static let shared = RedditService()
    
    func getTopEntries() -> Observable<[ResultTopEntries]> {
        return Observable.create { observer in
            self.getTopEntries(success: {
                observer.onNext($0)
                observer.onCompleted()
            },
            failure: { observer.onError($0) })
            return Disposables.create()
        }
    }
    
    private func getTopEntries(success: @escaping ([ResultTopEntries]) -> Void, failure: ((_ error: Error) -> Void)?) {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlString = "https://oauth.reddit.com/r/redditdev/top.json"
        guard let url = URL(string: urlString) else {
            failure?(RedditError(message: "The url is not an URL: \(urlString)"))
            return
        }
        
        var request = URLRequest(url: url)
        let token = "Bearer \(NetworkConfigs.sharedInstance.accessToken)"
        
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                failure?(RedditError(message: "Cant connect to the server"))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []),
                  let jsonDic = json as? [String: Any],
                  let jsonDicData = jsonDic["data"] as? [String: Any],
                  let childrenDic = jsonDicData["children"] as? [Any],
                  let jsonModel = try? JSONSerialization.data(withJSONObject: childrenDic),
                  let redditEntries = try? JSONDecoder.redditDecoder.decode([ResultTopEntries].self, from: jsonModel) else {
                failure?(RedditError(message: "Cant deserialize response from server"))
                return
            }
            print(redditEntries)
            success(redditEntries)
        })
        task.resume()
    }
        
    func requestToken() -> Observable<String> {
        return Observable.create { observer in
            self.requestToken(success: {
                observer.onNext($0)
                observer.onCompleted()
            },
            failure: { observer.onError($0) })
            return Disposables.create()
        }
    }
    
    private func requestToken(success: @escaping (String) -> Void, failure: ((_ error: Error) -> Void)?) {
        let ACCESS_TOKEN_URL = "https://www.reddit.com/api/v1/access_token"
        let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"

        let timeout = 15
        let uncodedClientIDAndPassword = "\(NetworkConfigs.sharedInstance.clientID):"
        guard let uncodedClientIDAndPasswordData = uncodedClientIDAndPassword.data(using: .utf8) else {
            failure?(RedditError(message: "Unexpected Error"))
            return
        }
        let encodedClientIDAndPassword = uncodedClientIDAndPasswordData.base64EncodedString(options: .lineLength64Characters)
        
        let authStr = "Basic \(encodedClientIDAndPassword)"
        guard let serviceUrl = URL(string: ACCESS_TOKEN_URL) else {
            failure?(RedditError(message: "Unexpected Error"))
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
                failure?(RedditError(message: "Cant deserialize response from server"))
                return
            }
            
            success(accessToken)
            return
        }.resume()
    }
}

struct RedditError: Error {
    let message: String
}

