//
//  SDBaseTableView.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/14.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import MJRefresh


class SDBaseTableView: UITableView {
    
    typealias tableCellSelectBlock = (SDBaseTableView,NSIndexPath)
    typealias tableViewRefreshCallBack = (SDBaseTableView,Bool)
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        if #available(iOS 110, *){
            self.contentInsetAdjustmentBehavior = .never
        }
        self.dataSource = self
        self.delegate = self
        self.tableFooterView = UIView.init()
        self.createHeader()
        self.createFooter()
        let nib = UINib(nibName: "TestTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        self.register(nib, forCellReuseIdentifier: "TestTableViewCell")

    }
    
    init() {
        super.init(frame: CGRect.init(), style: UITableViewStyle.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createHeader() {
        // 下拉刷新
        let header = MJRefreshNormalHeader {
            
        }
        header?.isAutomaticallyChangeAlpha = true
        self.mj_header = header
    }
    
    func createFooter() {
        let footer = MJRefreshAutoGifFooter {
            
        }
        self.mj_footer = footer
    }
    
    func tableviewDidSelectCallBack(selectCallBack : tableCellSelectBlock){
        
    }
}

extension SDBaseTableView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TestTableViewCell! = tableView .dequeueReusableCell(withIdentifier: "TestTableViewCell") as?TestTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension SDBaseTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NSLog("1111")
    }
    
}
