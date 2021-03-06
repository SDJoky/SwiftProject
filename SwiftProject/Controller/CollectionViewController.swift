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
import MJRefresh

class CollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    private var dataArr = [HomeNewsModel]()
    private var myCollectionView: UICollectionView!
    let pushAnim = SDPushAnimation()
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test1 did load")
        flowLayout.itemSize = CGSize.init(width:(SCREENW-10 * 2) / 2.0, height: (SCREENW-10 * 2) / 2.0 + 50)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        myCollectionView = UICollectionView(frame: CGRect.init(x: 0, y: 5, width: view.frame.size.width, height: view.frame.height - 49 - 30), collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.register(UINib.init(nibName:"CollectionViewCell" , bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        myCollectionView.dataSource = self
        myCollectionView.delegate = self;
        myCollectionView.alwaysBounceVertical = true
        view.addSubview(myCollectionView)
        // 下拉刷新
        let header = MJRefreshNormalHeader { [weak self] in
            self!.loadRequest()
        }
        header?.isAutomaticallyChangeAlpha = true
        myCollectionView.mj_header = header
        myCollectionView.mj_header .beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test1---will appear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test1---did appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test1---will disappear")


    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("test1---did Disappear")
    }

    deinit {
        print("test1--deinit")
    }

    private func loadRequest() {
        let url = "http://news-at.zhihu.com/api/4/news/latest"
        
        Alamofire.request(url,parameters:nil).responseJSON{ (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "请求失败")
                self.myCollectionView.mj_header.endRefreshing()
                return
            }
            if response.result.isSuccess {
                if let jsons = response.result.value {
                    print("\(jsons)")
                    let jsonDict = JSON(jsons)
                    if let data = jsonDict["top_stories"].arrayObject{
                        self.dataArr = data.compactMap({ HomeNewsModel.deserialize(from: $0 as? Dictionary) })
                    }
                    self.myCollectionView.reloadData()
                }
                self.myCollectionView.mj_header.endRefreshing()
                SVProgressHUD.showSuccess(withStatus: "请求成功")
            } else {
                SVProgressHUD.showError(withStatus: "请求失败了")
                self.myCollectionView.mj_header.endRefreshing()
            }
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
        let detailVC = Test1DetailViewController("_")
        navigationController?.delegate = pushAnim;
        detailVC.hidesBottomBarWhenPushed = true;//加上这句就可以隐藏推出的ViewController的Tabbar
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}


