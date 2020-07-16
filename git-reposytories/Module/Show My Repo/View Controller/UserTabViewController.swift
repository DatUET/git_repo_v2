//
//  UserTabViewController.swift
//  githubapi
//
//  Created by gem on 6/29/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class UserTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var repoTableView: UITableView!
    @IBOutlet weak var tabBer: UISegmentedControl!
    
    var arrRepoOfUser = [Repository]()
    var arrRepoPublicOfUser = [Repository]()
    var arrRepoPrivateOfUser = [Repository]()
    
    let cna = ConnectAPI()
    let cacheData = CacheData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTableView.dataSource = self
        repoTableView.delegate = self
        
        tabBer.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
        
        if Global.isConnect {
            cna.getRepoCurrentUser(callback: updateRepoUser(arrPublic:arrPrivate:))
        } else {
            arrRepoPublicOfUser = cacheData.getRepoCoreData(nameEntity: "MyRepositoryPublicDataCore")
            arrRepoPrivateOfUser = cacheData.getRepoCoreData(nameEntity: "MyRepositoryPrivateDataCore")
            arrRepoOfUser = arrRepoPublicOfUser
        }
    }
    
    func updateRepoUser(arrPublic: [Repository], arrPrivate: [Repository]) {
        for repo in arrPublic {
            arrRepoPublicOfUser.append(repo)
        }
        for repo in arrPrivate {
            arrRepoPrivateOfUser.append(repo)
        }
        arrRepoOfUser = arrPublic
        repoTableView.reloadData()
    }
    
    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            arrRepoOfUser = arrRepoPublicOfUser
        } else {
            arrRepoOfUser = arrRepoPrivateOfUser
        }
        self.repoTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRepoOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repoTableView.dequeueReusableCell(withIdentifier: "repoCell2") as! RepositoryTableViewCell
        let repo = arrRepoOfUser[indexPath.row]
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
