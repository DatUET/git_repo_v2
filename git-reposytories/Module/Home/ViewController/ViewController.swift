//
//  ViewController.swift
//  githubapi
//
//  Created by gem on 6/23/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var reposTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var starSortBtn: UIButton!
    @IBOutlet weak var forkSortBtn: UIButton!
    @IBOutlet weak var descSort: UIImageView!
    
    var curentPage = 1
    let cna = ConnectAPI()
    var mode = 0 // 0 for nomal, 1 for search, 2 for sort star, 3 for fork, 4 for
    var desc = true
    var order = ""
    var cacheData = CacheData()
    
    private let refreshControl = UIRefreshControl()
    
    var arrRepoHome = [Repository]() // lấy arr khi ko có mạng
    var arrRepo = [Repository]() // arr chung
    
    var loadMore = false
    var total_Repos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reposTableView.dataSource = self
        reposTableView.delegate = self
        reposTableView.refreshControl = refreshControl
        cna.isConnectedInternet()
        if Global.isConnect {
            cna.getListRepo(page: curentPage, callback: updateRepoList(arr:totalItem:))
        } else {
            arrRepoHome = cacheData.getRepoCoreData(nameEntity: "RepositoryDataCore")
            arrRepo = arrRepoHome
        }
        searchTF.addTarget(self, action: #selector(search), for: .editingDidEndOnExit)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        starSortBtn.addTarget(self, action: #selector(srarSort), for: .touchUpInside)
        forkSortBtn.addTarget(self, action: #selector(forkSort), for: .touchUpInside)
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
    }
    
    func updateRepoList(arr: [Repository], totalItem: Int) {
        for repo in arr {
            arrRepo.append(repo)
        }
        if totalItem > 1000 {
            total_Repos = 1000
        } else {
            total_Repos = totalItem
        }
        reposTableView.reloadData()
        loadMore = false
    }
    
    @objc func srarSort() {
        arrRepo.removeAll()
        reposTableView.reloadData()
        curentPage = 1
        if mode == 2 {
            desc = !desc
        }
        else {
            desc = true
            mode = 2
            starSortBtn.setTitleColor(.blue, for: .normal)
            forkSortBtn.setTitleColor(.black, for: .normal)
        }
        let searchKey = searchTF.text!
        if desc {
            order = "desc"
            descSort.image = UIImage(named: "down")
        } else {
            order = "asc"
            descSort.image = UIImage(named: "upload")
        }
        if Global.isConnect {
            cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "stars", order: order, callback: updateRepoList(arr:totalItem:))
        } else {
            arrRepo =  arrRepo.sorted { (repo1, repo2) -> Bool in
                let star1 = repo1.star
                let star2 = repo2.star
                if desc {
                    return star1 > star2
                } else {
                    return star1 < star2
                }
            }
            self.reposTableView.reloadData()
        }
    }
    
    @objc func forkSort() {
        arrRepo.removeAll()
        reposTableView.reloadData()
        curentPage = 1
        if mode == 3 {
            desc = !desc
        }
        else {
            desc = true
            mode = 3
            forkSortBtn.setTitleColor(.blue, for: .normal)
            starSortBtn.setTitleColor(.black, for: .normal)
        }
        let searchKey = searchTF.text!
        if desc {
            order = "desc"
            descSort.image = UIImage(named: "down")
        } else {
            order = "asc"
            descSort.image = UIImage(named: "upload")
        }
        if Global.isConnect {
            cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "forks", order: order, callback: updateRepoList(arr:totalItem:))
        } else {
            arrRepo =  arrRepo.sorted { (repo1, repo2) -> Bool in
                let fork1 = repo1.fork
                let fork2 = repo2.fork
                if desc {
                    return fork1 > fork2
                } else {
                    return fork1 < fork2
                }
            }
            self.reposTableView.reloadData()
        }
    }
    
    @objc func refresh() {
        if Global.isConnect {
            let searchKey = searchTF.text!
            arrRepo.removeAll()
            self.reposTableView.reloadData()
            curentPage = 1
            if mode == 0 {
                cna.getListRepo(page: 1, callback: updateRepoList(arr:totalItem:))
            } else if mode == 1{
                cna.searchKey(page: 1, searchKey: searchKey, callback: updateRepoList(arr:totalItem:))
            } else if mode == 2 {
                cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "stars", order: order, callback: updateRepoList(arr:totalItem:))
            } else if mode == 3 {
                
                cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "forks", order: order, callback: updateRepoList(arr:totalItem:))
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc func search() {
        arrRepo.removeAll()
        reposTableView.reloadData()
        let searchKey = searchTF.text!
        descSort.image = nil
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
        curentPage = 1
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
        if !searchKey.isEmpty{
            mode = 1
            if Global.isConnect {
                cna.searchKey(page: curentPage, searchKey: searchTF.text!, callback: updateRepoList(arr:totalItem:))
            } else {
                arrRepo = arrRepoHome
                arrRepo = arrRepo.filter({ (repo) -> Bool in
                    return repo.reponame.lowercased().contains(searchKey.lowercased()) || repo.username.lowercased().contains(searchKey.lowercased())
                })
                self.reposTableView.reloadData()
            }
        } else {
            mode = 0
            arrRepo.removeAll()
            self.reposTableView.reloadData()
            if Global.isConnect {
                cna.getListRepo(page: curentPage, callback: updateRepoList(arr:totalItem:))
            } else {
                arrRepo = arrRepoHome
                self.reposTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reposTableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepositoryTableViewCell
        let repo = arrRepo[indexPath.row]
        cell.reponame.text = repo.reponame
        cell.username.text = repo.username
        cell.numberStar.text = String(repo.star)
        cell.numberFork.text = String(repo.fork)
        cell.numberWatcher.text = String(repo.watch)
        cell.numberIssue.text = String(repo.issue)
        cell.lastUpdate.text = repo.lastCommit
        cell.useravatar.sd_setImage(with: URL(string: repo.avatar), placeholderImage: UIImage(named: "issue.png"))
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let webRepo = storyboard.instantiateViewController(withIdentifier: "WebRepoViewController") as? WebRepoViewController
        webRepo?.urlRepo = arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(webRepo!, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        //debugPrint("offset y = \(offsetY) and \(contenHeight - scrollView.frame.height)")
        if offsetY > contenHeight - scrollView.frame.height && offsetY > 0 {
            if !loadMore && arrRepo.count < total_Repos {
                nextPage()
            }
        }
    }
    
    func nextPage() {
        if Global.isConnect {
            loadMore =  true
            curentPage += 1
            if mode == 0 {
                cna.getListRepo(page: curentPage, callback: updateRepoList(arr:totalItem:))
            }
            else if mode == 1 {
                cna.searchKey(page: curentPage, searchKey: searchTF.text!, callback: updateRepoList(arr:totalItem:))
            } else if mode == 2 {
                cna.sortRepo(page: curentPage, searchKey: searchTF.text!, typeSort: "stars", order: order, callback: updateRepoList(arr:totalItem:))
            } else if mode == 3 {
                cna.sortRepo(page: curentPage, searchKey: searchTF.text!, typeSort: "forks", order: order, callback: updateRepoList(arr:totalItem:))
            }
        }
    }
}
