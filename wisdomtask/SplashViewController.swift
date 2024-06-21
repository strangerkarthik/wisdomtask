//
//  splashViewController.swift
//  wisdomtask
//
//  Created by JAISHIVA SN on 21/06/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            sceneDelegate.setHomeScreen()
        }
        
    }
    


}
