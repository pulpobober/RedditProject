//
//  NetworkRepository.swift
//  RedditProject
//
//  Created by Ivan Bober on 07/12/2020.
//

import Foundation
import UIKit

//TODO: Add protocol
class NetworkRepository {
    var accessToken: String = ""
    
    //TODO: Devolver un observable, evitar el ?
    static func getTopEntries() -> [RedditEntrie]? {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "https://oauth.reddit.com/r/redditdev/top.json") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        let token = "Bearer \(NetworkConfigs.sharedInstance.accessToken)"
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

//            if let httpResponse = response as? HTTPURLResponse {
//                let statusCode = httpResponse.statusCode
//                print(statusCode)
//            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []),
                  let jsonDic = json as? [String: Any],
                  let jsonDicData = jsonDic["data"] as? [String: Any],
                  let childrenDic = jsonDicData["children"] as? [Any],
                  let jsonModel = try? JSONSerialization.data(withJSONObject: childrenDic),
                  let redditEntries = try? JSONDecoder.redditDecoder.decode([ResultTopEntries].self, from: jsonModel)
                  
            else {
                return
                //error
            }
            
            print(redditEntries)

        })
        task.resume()
        return nil
    }
    
    static func requestToken() {
        let ACCESS_TOKEN_URL = "https://www.reddit.com/api/v1/access_token"
        let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        let DEVICE_ID = "DO_NOT_TRACK_THIS_DEVICE"

        let timeout = 15
        let uncodedClientIDAndPassword = "\(NetworkConfigs.sharedInstance.clientID):"
        guard let uncodedClientIDAndPasswordData = uncodedClientIDAndPassword.data(using: .utf8) else {
            return
        }
        let encodedClientIDAndPassword = uncodedClientIDAndPasswordData.base64EncodedString(options: .lineLength64Characters)
        
        let authStr = "Basic \(encodedClientIDAndPassword)"
        guard let serviceUrl = URL(string: ACCESS_TOKEN_URL) else {
            print("error")
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
            if data != nil {
                do {
                    if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String: Any] {
                        NetworkConfigs.sharedInstance.accessToken = json["access_token"] as? String ?? ""
                    } else {
                        NetworkConfigs.sharedInstance.accessToken = ""
                    }
                }
            }
            return
        }.resume()
    }
}

