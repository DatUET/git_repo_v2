//
//  ProfileViewController.swift
//  git-reposytories
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginView: LoginView!
    @IBOutlet weak var table: UITableView!
    
    let loginCtl = LoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        setUpLoginScreen()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    func setUpLoginScreen() {
        if Global.isLoggedIn {
            loginCtl.getInfo()
            loginView.isHidden = true
        } else {
            loginView.isHidden = false
        }
        table.reloadData()
    }
    
    @objc func reload() {
        setUpLoginScreen()
    }
    
    @objc func gotoMyRepo() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let myrepo = storyboard.instantiateViewController(withIdentifier: "MyRepoController") as! UserTabViewController
        navigationController?.pushViewController(myrepo, animated: true)
    }
    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            loginView.isHidden = false
            loginCtl.logOut()
            setUpLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell") as! UserDetailTableViewCell
            cell.avatarImage.sd_setImage(with: Auth.auth().currentUser?.photoURL, placeholderImage: UIImage(named: "issue.png"))
            cell.nameLb.text = Global.userName
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
}
