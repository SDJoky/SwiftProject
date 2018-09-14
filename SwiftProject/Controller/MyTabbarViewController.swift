//
//  MyTabbarViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/5/28.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class MyTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.orange
        addChildViewControllers()
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func addChildViewControllers() {
        setChildViewController(Test1ViewController(), title: "Collection", imageName: "shouye_nor",selectName: "shouye_hi")
        setChildViewController(Test2ViewController(), title: "Test2", imageName: "live_nor",selectName: "kecheng_hi")
        setChildViewController(ThirdViewController(), title: "Table", imageName: "live_nor",selectName: "zhibo_hi")
    }
    
    private func setChildViewController(_ childVC:UIViewController ,title:String ,imageName:String ,selectName:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage (named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage (named: selectName)?.withRenderingMode(.alwaysOriginal)
        let navBar : UINavigationController = UINavigationController(rootViewController: childVC)
        addChildViewController(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
