//
//  ViewController.swift
//  githubapi
//
//  Created by gem on 6/23/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    var arrRepoHome = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reposTableView.dataSource = self
        reposTableView.delegate = self
        reposTableView.refreshControl = refreshControl
        cna.isConnectedInternet()
        if Contains.isConnect {
            cna.getListRepo(page: curentPage, repoTableView: self.reposTableView)
        } else {
            arrRepoHome = cacheData.getRepoCoreData(nameEntity: "RepositoryDataCore")
            Contains.arrRepo = arrRepoHome
        }
        searchTF.addTarget(self, action: #selector(search), for: .editingDidEndOnExit)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        starSortBtn.addTarget(self, action: #selector(srarSort), for: .touchUpInside)
        forkSortBtn.addTarget(self, action: #selector(forkSort), for: .touchUpInside)
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
        
    }
    
    @objc func srarSort() {
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
        if Contains.isConnect {
            cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "stars", order: order, repoTableView: self.reposTableView)
        } else {
            Contains.arrRepo =  Contains.arrRepo.sorted { (repo1, repo2) -> Bool in
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
        if Contains.isConnect {
            cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "forks", order: order, repoTableView: self.reposTableView)
        } else {
            Contains.arrRepo =  Contains.arrRepo.sorted { (repo1, repo2) -> Bool in
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
        if Contains.isConnect {
            let searchKey = searchTF.text!
            Contains.arrRepo.removeAll()
            self.reposTableView.reloadData()
            curentPage = 1
            if mode == 0 {
                cna.getListRepo(page: 1, repoTableView: self.reposTableView)
            } else if mode == 1{
                cna.searchKey(page: 1, searchKey: searchKey, repoTableView: reposTableView)
            } else if mode == 2 {
                cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "stars", order: order, repoTableView: self.reposTableView)
            } else if mode == 3 {
                
                cna.sortRepo(page: 1, searchKey: searchKey, typeSort: "forks", order: order, repoTableView: self.reposTableView)
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc func search() {
        let searchKey = searchTF.text!
        descSort.image = nil
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
        curentPage = 1
        starSortBtn.setTitleColor(.black, for: .normal)
        forkSortBtn.setTitleColor(.black, for: .normal)
        if !searchKey.isEmpty{
            mode = 1
            if Contains.isConnect {
                cna.searchKey(page: curentPage, searchKey: searchTF.text!, repoTableView: reposTableView)
            } else {
                Contains.arrRepo = arrRepoHome
                Contains.arrRepo = Contains.arrRepo.filter({ (repo) -> Bool in
                    return repo.reponame.lowercased().contains(searchKey.lowercased()) || repo.username.lowercased().contains(searchKey.lowercased())
                })
                self.reposTableView.reloadData()
            }
        } else {
            mode = 0
            Contains.arrRepo.removeAll()
            self.reposTableView.reloadData()
            if Contains.isConnect {
                cna.getListRepo(page: curentPage, repoTableView: self.reposTableView)
            } else {
                Contains.arrRepo = arrRepoHome
                self.reposTableView.reloadData()
            }
        }
    }
    
    @objc func nextPage() {
        if Contains.isConnect {
            Contains.loadMore =  true
            curentPage += 1
            if mode == 0 {
                cna.getListRepo(page: curentPage, repoTableView: self.reposTableView)
            }
            else if mode == 1 {
                cna.searchKey(page: curentPage, searchKey: searchTF.text!, repoTableView: reposTableView)
            } else if mode == 2 {
                cna.sortRepo(page: curentPage, searchKey: searchTF.text!, typeSort: "stars", order: order, repoTableView: reposTableView)
            } else if mode == 3 {
                cna.sortRepo(page: curentPage, searchKey: searchTF.text!, typeSort: "forks", order: order, repoTableView: reposTableView)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.arrRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reposTableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepositoryTableViewCell
        let repo = Contains.arrRepo[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webRepo = storyboard?.instantiateViewController(withIdentifier: "WebRepoViewController") as? WebRepoViewController
        webRepo?.urlRepo = Contains.arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(webRepo!, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        //debugPrint("offset y = \(offsetY) and \(contenHeight - scrollView.frame.height)")
        if offsetY > contenHeight - scrollView.frame.height && offsetY > 0 {
            if !Contains.loadMore && Contains.arrRepo.count < Contains.total_Repos {
                nextPage()
            }
        }
    }
}
