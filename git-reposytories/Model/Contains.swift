//
//  Contains.swift
//  githubapi
//
//  Created by gem on 6/24/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class Contains {
    public static var arrRepo = [Repository]()
    public static var loadMore = false
    public static var total_Repos = 0
    
    public static var avatarUser = ""
    public static var userName = ""
    public static var arrRepoOfUser = [Repository]()
    public static var arrRepoPublicOfUser = [Repository]()
    public static var arrRepoPrivateOfUser = [Repository]()
    public static var loadMoreCurrent = false
    public static var total_ReposCurrentUser = 0
    public static var accessToken = ""
    
    public static var isConnect = true
}
