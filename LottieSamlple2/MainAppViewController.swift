//
//  MainAppViewController.swift
//  LottieSamlple2
//
//  Created by TSUNE on 2021/03/23.
//

import UIKit

class MainAppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped() {
        showIntroApp()
    }
    private func showIntroApp() {
        let introAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "intro")
        if let windoewScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windoewScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = introAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCurlUp,
                              animations: nil,
                              completion: nil)
        }
    }
}
