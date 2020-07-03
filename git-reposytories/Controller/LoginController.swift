//
//  LoginController.swift
//  git-reposytories
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class LoginController {
    public func saveInfo(username: String, avatar: String, token: String) {
        let preferences = UserDefaults.standard
        preferences.set(username, forKey: "username")
        preferences.set(avatar, forKey: "avatar")
        preferences.set(token, forKey: "token")
    }
    
    public func getInfo() {
        let preferences = UserDefaults.standard
        Contains.userName = preferences.string(forKey: "username")!
        Contains.avatarUser = preferences.string(forKey: "avatar")!
        Contains.accessToken = preferences.string(forKey: "token")!
    }
    
    public func logOut() {
        saveInfo(username: "", avatar: "", token: "")
        Contains.userName = ""
        Contains.avatarUser = ""
        Contains.accessToken = ""
    }
}
