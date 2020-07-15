//
//  Contains.swift
//  githubapi
//
//  Created by gem on 6/24/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

// FIXME: lớp này có ý nghĩa như lớp Global.swift mô tả trong file excel
// FIXME: hạn chế lưu thông tin vào biến static để dùng chung vì các nhiều nơi dùng chung càng khó kiểm soát thay đổi
// ví dụ như thông tin repo, loadmore... thì chỉ nên lưu ở view controller thuộc module tương ứng
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
