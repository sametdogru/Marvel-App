//
//  SplashVC.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import UIKit
import Lottie

class SplashVC: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopMode = .loop
        animationView.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            let maintabbar = TabBarController.instantiate()
            self.navigationController?.pushViewController(maintabbar, animated: true)
        }
    }
}

// MARK : - StoryboardInstantiable
extension SplashVC: StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "SplashVC" }
}
