//
//  ThirdViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/14.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    lazy var table : SDBaseTableView = { [weak self] in
        let theV = SDBaseTableView.init(frame: (self?.view.bounds)!, style: UITableViewStyle.plain)
        theV.frame = (self?.view.bounds)!;
        return theV;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        table.reloadData()
    }
    
    

}
