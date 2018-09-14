//
//  Test1ViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/5/28.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class Test1ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    var dataArr = [HomeNewsModel]()
    private var myCollectionView: UICollectionView!
    let pushAnim = SDPushAnimation()
    
    let flowLayout = UICollectionViewFlowLayout()
    let device_id: Int = 6096495334
    let iid: Int = 5034850950
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.itemSize = CGSize.init(width: 105, height: 70)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        self.myCollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 15, width: self.view.frame.size.width, height: self.view.frame.height - 49 - 15), collectionViewLayout: flowLayout)
        self.myCollectionView.backgroundColor = UIColor.white
        self.myCollectionView.register(UINib.init(nibName:"CollectionViewCell" , bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self;
        self.myCollectionView.alwaysBounceVertical = true
        self.view.addSubview(self.myCollectionView)
        // 下拉刷新
        let header = MJRefreshNormalHeader { [weak self] in
            self?.loadRequest()
        }
        header?.isAutomaticallyChangeAlpha = true
        self.myCollectionView.mj_header = header
        self.myCollectionView.mj_header .beginRefreshing()
    }

    private func loadRequest() {
        let url = "https://is.snssdk.com/article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,"iid":iid]
        
        Alamofire.request(url,parameters:params).responseJSON{ (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "请求失败")
                self.myCollectionView.mj_header.endRefreshing()
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                print("\(json)")
                guard json["message"] == "success" else { return }
                let dataDict = json["data"].dictionary
                if let data = dataDict!["data"]!.arrayObject{
                    self.dataArr = data.compactMap({ HomeNewsModel.deserialize(from: $0 as? Dictionary) })
                }
                self.myCollectionView.reloadData()
            }
            self.myCollectionView.mj_header.endRefreshing()
            SVProgressHUD.showSuccess(withStatus: "请求成功")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        if dataArr.count>0 {
            cell.homeNewsModel = dataArr[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = Test1DetailViewController()
        if indexPath.row % 2 == 0 {
            self.navigationController?.delegate = pushAnim;
            detailVC.hidesBottomBarWhenPushed = true;//加上这句就可以隐藏推出的ViewController的Tabbar
            self.navigationController?.pushViewController(detailVC, animated: true)
        }else
        {
            detailVC.transitioningDelegate = pushAnim;
            present(detailVC, animated: true, completion: nil)
        }
        
    }
}


