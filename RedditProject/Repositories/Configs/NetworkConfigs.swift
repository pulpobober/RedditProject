//
//  NetworkConfigs.swift
//  RedditProject
//
//  Created by Ivan Bober on 08/12/2020.
//

import Foundation

struct NetworkConfigs {
    let developerName: String = "pulpobober"
    let redirectURI: String = "reddit-test://oauth-callback"
    let clientID: String = "YNk9-n6pPfX0-Q"
    
    let version = Bundle.infoValueInMainBundle(for: "CFBundleShortVersionString") as? String ?? "1.0"
    let bundleIdentifier = Bundle.infoValueInMainBundle(for: "CFBundleIdentifier") as? String ?? ""
   
    var accessToken: String = ""
    
    static var sharedInstance = NetworkConfigs()
}
