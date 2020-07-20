//
//  ConnectAPI.swift
//  githubapi
//
//  Created by gem on 6/23/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConnectAPI{
    let URL = "https://api.github.com/search/repositories?q="
    let parameters: Parameters = ["foo": "bar"]
    let cacheData = CacheData()
    
    public func getListRepo(page: Int, callback: @escaping ([Repository], Int) -> Void) {
        if page == 1 {
            cacheData.deleteAllRepoDataCore(nameEntity: "RepositoryDataCore")
        }
        Alamofire.request(self.URL + "language:&per_page=50&page=\(page)")
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                if response.result.isSuccess {
                    do {
                        let json = try JSON(data: response.data!)
                        let totalItem = json["total_count"].intValue
                        
                        var arrRepoTemp = [Repository]()
                        if let items = json["items"].array {
                            for item in items {
                                let repo = self.pareJson(json: item)
                                arrRepoTemp.append(repo)
                                self.cacheData.saveRepoToCoreData(repo: repo, nameEntity: "RepositoryDataCore")
                            }
                        }
                        callback(arrRepoTemp, totalItem)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func searchKey(page: Int, searchKey: String, callback: @escaping ([Repository], Int) -> Void) {
        Alamofire.request(self.URL + "\(searchKey)&language:&per_page=50&page=\(page)")
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                if response.result.isSuccess {
                    do {
                        let json = try JSON(data: response.data!)
                        let totalItem = json["total_count"].intValue
                        var arrRepoTemp = [Repository]()
                        if let items = json["items"].array {
                            for item in items {
                                let repo = self.pareJson(json: item)
                                arrRepoTemp.append(repo)
                            }
                        }
                        callback(arrRepoTemp, totalItem)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func sortRepo(page: Int, searchKey: String, typeSort: String, order: String, callback: @escaping ([Repository], Int) -> Void) {
        // build url
        var urlAPI = self.URL
        if !searchKey.isEmpty {
            urlAPI += searchKey + "&per_page=50&page=\(page)"
        }
        else {
            urlAPI += "language:&per_page=50&page=\(page)"
        }
        urlAPI += "&sort=\(typeSort)&order=\(order)"
        
        Alamofire.request(urlAPI)
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                if  response.result.isSuccess {
                    do {
                        let json = try JSON(data: response.data!)
                        let totalItem = json["total_count"].intValue
                        var arrRepoTemp = [Repository]()
                        if let items = json["items"].array {
                            for item in items {
                                let repo = self.pareJson(json: item)
                                arrRepoTemp.append(repo)
                            }
                        }
                        callback(arrRepoTemp, totalItem)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func getRepoCurrentUser(callback: @escaping ([Repository], [Repository]) -> Void) {
        self.cacheData.deleteAllRepoDataCore(nameEntity: "MyRepositoryPublicDataCore")
        self.cacheData.deleteAllRepoDataCore(nameEntity: "MyRepositoryPrivateDataCore")
        let url = "https://api.github.com/user/repos"
        
        let headers = [
            "Authorization": "token " + Global.accessToken
        ]
        Alamofire.request(url, method: .get, headers: headers)
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                if  response.result.isSuccess {
                    do {
                        var arrRepoPublicUserTemp = [Repository]()
                        var arrRepoPrivateUserTemp = [Repository]()
                        let json = try JSON(data: response.data!)
                        if let items = json.array {
                            for item in items {
                                let repo = self.pareJson(json: item)
                                if !item["private"].boolValue {
                                    arrRepoPublicUserTemp.append(repo)
                                    self.cacheData.saveRepoToCoreData(repo: repo, nameEntity: "MyRepositoryPublicDataCore")
                                } else {
                                    arrRepoPrivateUserTemp.append(repo)
                                    self.cacheData.saveRepoToCoreData(repo: repo, nameEntity: "MyRepositoryPrivateDataCore")
                                }
                            }
                        }
                        callback(arrRepoPublicUserTemp, arrRepoPrivateUserTemp)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    func pareJson(json: JSON) -> Repository {
        let avatar = json["owner"]["avatar_url"].stringValue
        let username = json["owner"]["login"].stringValue
        let reponame = json["name"].stringValue
        let url = json["html_url"].stringValue
        let star = json["stargazers_count"].intValue
        let watch = json["watchers_count"].intValue
        let fork = json["forks_count"].intValue
        let issue = json["open_issues_count"].intValue
        let lastCommit = json["updated_at"].stringValue
        return Repository.init(avatar: avatar, username: username, reponame: reponame, url: url, star: star, watch: watch, fork: fork, issue: issue, lastCommit: lastCommit)
    }
    
    public func isConnectedInternet() {
        Global.isConnect = NetworkReachabilityManager()!.isReachable
    }
}
