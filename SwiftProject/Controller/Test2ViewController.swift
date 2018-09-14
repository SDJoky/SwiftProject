//
//  Test2ViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/5/28.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import Tiercel
import SnapKit
import SVProgressHUD
import Kingfisher

class Test2ViewController: UIViewController {
    
    //Tiercel 下载器使用
    lazy var downloadManager = TRManager()
    lazy var urlStr = "https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/OfficeMac/Microsoft_Office_2016_16.10.18021001_Installer.pkg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInterface()
    }
    
    func loadInterface() {
        
        let tipLbl = UILabel()
        tipLbl.text = "下载之Tiercel使用："
        tipLbl.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(tipLbl)
        tipLbl.snp.remakeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(20)
            make.top.equalTo(15)
        }
        
        let downLoadBtn:UIButton = creatBtn(title: "开始下载", titleColor: UIColor.white, backGroundColor: UIColor.purple)
        downLoadBtn.addTarget(self, action: #selector(downLoadAction(_:)), for: .touchUpInside)
        self.view.addSubview(downLoadBtn)
        downLoadBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.left.equalTo(tipLbl.snp.right)
            make.top.equalTo(tipLbl)
        }
        
        let suspendBtn:UIButton = creatBtn(title: "暂停下载", titleColor: UIColor.white, backGroundColor: UIColor.purple)
        suspendBtn.addTarget(self, action: #selector(suspendAction(_:)), for: .touchUpInside)
        self.view.addSubview(suspendBtn)
        suspendBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.equalTo(downLoadBtn)
            make.left.equalTo(downLoadBtn.snp.right).offset(10)
        }
        
        let restartBtn:UIButton = creatBtn(title: "重新开始下载", titleColor: UIColor.white, backGroundColor: UIColor.purple)
        restartBtn.addTarget(self, action: #selector(restartAction(_:)), for: .touchUpInside)
        self.view.addSubview(restartBtn)
        restartBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.top.equalTo(suspendBtn.snp.bottom).offset(15)
            make.left.equalTo(tipLbl)
        }
        
        //KingfisherManager 设置超时时间
        KingfisherManager.shared.downloader.downloadTimeout = 5
        //缓存
        let cache = KingfisherManager.shared.cache
        // 设置硬盘最大缓存50M ，默认无限
        cache.maxDiskCacheSize = 50 * 1024 * 1024
        // 设置硬盘最大保存3天 ， 默认1周
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 3
        // 获取硬盘缓存的大小
        cache.calculateDiskCacheSize { (size) -> () in
            NSLog("disk size in bytes: \(size)")
        }
        
        /*------------------Kingfisher使用-------------------------------*/
        let kingImg = UIImageView()
        self.view.addSubview(kingImg)
        //默认情况下Kingfisher使用url当做cache(缓存)的key
        //Kingfisher 默认先从内存和硬盘搜 ，如果没找到才去URL down
        kingImg.kf.setImage(with: URL(string:"http://www.08lr.cn/uploads/allimg/170513/1-1F513100951.jpg"), placeholder: UIImage(named: "BannerDefault"), options: nil, progressBlock: { (receivedSize, totalSize) in
            let progress = Float(receivedSize) / Float(totalSize)
            SVProgressHUD.showProgress(progress)
        }) { (image, error, cacheType, url) in
            SVProgressHUD.dismiss()
        }
        
        kingImg.snp.remakeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.top.equalTo(restartBtn.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
        }
    }
    
    func creatBtn(title:String,titleColor:UIColor,backGroundColor:UIColor) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for:.normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = backGroundColor
        return btn
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
    
    @objc func downLoadAction(_ sender: UIButton) {
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
   
    @objc func restartAction(_ sender: Any) {
        downloadManager.start(urlStr)
    }
    
    
    @objc func suspendAction(_ sender: UIButton) {
        downloadManager.suspend(urlStr)
    }
    
    // 由于Tiercel是使用URLSession实现的，session需要手动销毁，所以当不再需要使用Tiercel也需要手动销毁
    deinit {
        downloadManager.invalidate()
        
        let cache = KingfisherManager.shared.cache
        //清理内存缓存
        cache.clearMemoryCache()
        
        // 清理硬盘缓存，这是一个异步的操作
        cache.clearDiskCache()
        
        // 清理过期或大小超过磁盘限制缓存。这是一个异步的操作
        cache.cleanExpiredDiskCache()
    }

}
