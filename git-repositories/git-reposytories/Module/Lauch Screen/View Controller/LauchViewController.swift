//
//  LauchViewController.swift
//  git-reposytories
//
//  Created by gem on 7/16/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class LauchViewController: UIViewController {
    @IBOutlet weak var copyrightLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        viewDidAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Thread.sleep(forTimeInterval: 2.0)
        
        let navgation = self.storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navgation
    }
}
