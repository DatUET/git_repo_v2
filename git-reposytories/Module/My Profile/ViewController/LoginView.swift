//
//  LoginView.swift
//  githubapi
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginView: UIView {
    @IBOutlet var contentView: LoginView!
    @IBOutlet weak var loginBtn: UIButton!
    var provider = OAuthProvider(providerID: "github.com")
    let loginCtr = LoginController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("LoginScreen", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            self.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func login() {
        provider.scopes = ["user:email",
                            "repo"]
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                debugPrint(error)
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        debugPrint(error)
                    }
                    let username = authResult?.additionalUserInfo?.profile!["login"] as! String
                    let avatar = authResult?.additionalUserInfo?.profile!["avatar_url"] as! String
                    let cre = authResult?.credential as! OAuthCredential
                    let token = cre.accessToken
                    self.loginCtr.saveInfo(username: username, avatar: avatar, token: token!)
                    NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                    
                }
            }
        }
    }
}
