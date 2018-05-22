//
//  ViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/4/24.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import Tiercel

class ViewController: UIViewController {
    //Tiercel 下载器使用
    lazy var downloadManager = TRManager()
    lazy var urlStr = "https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/OfficeMac/Microsoft_Office_2016_16.10.18021001_Installer.pkg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
}

