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
        tabBar.tintColor = UIColor.orange
        addChildViewControllers()
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    private func addChildViewControllers() {
        setChildViewController(ThemeViewController(), title: "Theme", imageName: "wangke_nor",selectName: "zhibo_hi")
        setChildViewController(CollectionViewController(), title: "Collection", imageName: "shouye_nor",selectName: "shouye_hi")
        setChildViewController(DownLoadViewController(), title: "Test2", imageName: "wangke_nor",selectName: "kecheng_hi")
        setChildViewController(FlowLayoutViewController(), title: "瀑布流", imageName: "shouye_nor",selectName: "kecheng_hi")
    }
    
    private func setChildViewController(_ childVC:UIViewController ,title:String ,imageName:String ,selectName:String) {
        childVC.title = title;
        childVC.tabBarItem.image = UIImage (named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage (named: selectName)?.withRenderingMode(.alwaysOriginal)
        let navBar : UINavigationController = UINavigationController(rootViewController: childVC)
        addChild(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
