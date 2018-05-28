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
        addChildViewControllers()
        self.tabBar.tintColor = UIColor.red
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func addChildViewControllers() {
        setChildViewController(Test1ViewController(), title: "网络解析使用", imageName: "mine_tabbar_normal")
        setChildViewController(Test2ViewController(), title: "Test2", imageName: "mine_tabbar_normal")
    }
    
    private func setChildViewController(_ childVC:UIViewController ,title:String ,imageName:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named:imageName)
        childVC.tabBarItem.selectedImage = UIImage (named: "mine_tabbar_select")
        let navBar : UINavigationController = UINavigationController(rootViewController: childVC)
        addChildViewController(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
