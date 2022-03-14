//
//  TabBarController.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return  .lightContent
    }
}

// MARK : - StoryboardInstantiable
extension TabBarController: StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "TabBarController" }
}
