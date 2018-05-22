//
//  ViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/4/24.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import Tiercel
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class ViewController: UIViewController {
    //Tiercel 下载器使用
    lazy var downloadManager = TRManager()
    lazy var urlStr = "https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/OfficeMac/Microsoft_Office_2016_16.10.18021001_Installer.pkg"
    
    let device_id: Int = 6096495334
    let iid: Int = 5034850950
    //fileprivate关键字将对实体的访问权限于它声明的源文件
    var dataArr = [HomeNewsModel]()
    let flowLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myCollectionView.register(UINib.init(nibName:"CollectionViewCell" , bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        flowLayout.itemSize = CGSize.init(width: 105, height: 70)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        self.myCollectionView.alwaysBounceVertical = true
        self.myCollectionView.collectionViewLayout = flowLayout
        
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
    
    // MARK :Tiercel使用
    /*
     取消下载，没有下载完成的任务会被移除，但保留没有下载完成的缓存文件
     downloadManager.cancel(URLString)
     
     移除下载，已经完成的任务也会被移除，没有下载完成的缓存文件会被删除，已经下载完成的文件可以选择是否保留
     downloadManager.remove(URLString, completely: false)
     
     如果调用suspend暂停了下载，可以调用这个方法继续下载
     downloadManager.start(URLString)
     */
    
    @IBAction func downLoadAction(_ sender: UIButton) {
        
        //下载回调
        downloadManager.download(urlStr, fileName: "小黄人", progressHandler: { (task) in
            let progress = task.progress.fractionCompleted
            print("下载进度：\(progress)")
        }, successHandler: { (task) in
            print("下载被中止，或已完成")
        }) { (task) in
            print("很遗憾，下载失败了")
        }
    }
    
    @IBAction func restartAction(_ sender: Any) {
        downloadManager.start(urlStr)
    }
    
    
    @IBAction func suspendAction(_ sender: UIButton) {
        downloadManager.suspend(urlStr)
    }
    
    // 由于Tiercel是使用URLSession实现的，session需要手动销毁，所以当不再需要使用Tiercel也需要手动销毁
    deinit {
        downloadManager.invalidate()
    }
    
}

extension ViewController : UICollectionViewDataSource,UICollectionViewDelegate {
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
        SVProgressHUD.showInfo(withStatus: "\(dataArr[indexPath.item].name)")
    }
    
}



