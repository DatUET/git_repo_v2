//
//  ProfileViewController.swift
//  git-reposytories
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loginView: LoginView!
    @IBOutlet weak var table: UITableView!
    
    let loginCtl = LoginController()
    let cna = ConnectAPI()
    let cacheData = CacheData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        if Auth.auth().currentUser != nil {
            loginView.isHidden = true
            loginCtl.getInfo()
            if Contains.isConnect {
                cna.getRepoCurrentUser(table: table)
            } else {
                Contains.arrRepoPublicOfUser = cacheData.getRepoCoreData(nameEntity: "MyRepositoryPublicDataCore")
                Contains.arrRepoPrivateOfUser = cacheData.getRepoCoreData(nameEntity: "MyRepositoryPrivateDataCore")
                Contains.arrRepoOfUser = Contains.arrRepoPublicOfUser
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    @objc func reload() {
        table.reloadData()
        viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell") as! UserDetailTableViewCell
            cell.avatarImage.sd_setImage(with: URL(string: Contains.avatarUser), placeholderImage: UIImage(named: "issue.png"))
            cell.nameLb.text = Contains.userName
            cell.repoCountLb.text = "\(Contains.arrRepoPublicOfUser.count + Contains.arrRepoPrivateOfUser.count) repositories"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRepoCell") as! MyReposTableViewCell
            cell.myRepoBtn.addTarget(self, action: #selector(gotoMyRepo), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignOutCell") as! SignOutTableViewCell
            cell.signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func gotoMyRepo() {
        let myrepo = storyboard?.instantiateViewController(withIdentifier: "MyRepoController") as! UserTabViewController
        navigationController?.pushViewController(myrepo, animated: true)
    }
    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            loginView.isHidden = false
            loginCtl.logOut()
            viewDidLoad()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
