//
//  LoginController.swift
//  git-reposytories
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class LoginController {
    public func saveInfo(isLoggedIn: Bool, username: String, token: String) {
        let preferences = UserDefaults.standard
        preferences.set(isLoggedIn, forKey: "isLoggedIn")
        preferences.set(username, forKey: "username")
        preferences.set(token, forKey: "token")
    }
    
    public func getInfo() {
        let preferences = UserDefaults.standard
        Global.isLoggedIn = preferences.bool(forKey: "isLoggedIn")
        Global.userName = preferences.string(forKey: "username")!
        Global.accessToken = preferences.string(forKey: "token")!
    }
    
    public func logOut() {
        saveInfo(isLoggedIn: false, username: "", token: "")
        Global.userName = ""
        Global.accessToken = ""
    }
}
