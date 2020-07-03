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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTableView.dataSource = self
        repoTableView.delegate = self
        
        tabBer.addTarget(self, action: #selector(changeTab(sender:)), for: .valueChanged)
    }
    
    @objc func changeTab(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Contains.arrRepoOfUser = Contains.arrRepoPublicOfUser
        } else {
            Contains.arrRepoOfUser = Contains.arrRepoPrivateOfUser
        }
        self.repoTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //debugPrint(Contains.arrRepo.count)
        return Contains.arrRepoOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repoTableView.dequeueReusableCell(withIdentifier: "repoCell2") as! RepositoryTableViewCell
        let repo = Contains.arrRepoOfUser[indexPath.row]
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
