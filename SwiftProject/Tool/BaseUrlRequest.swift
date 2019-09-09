//
//  BaseUrlRequest.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/9/9.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
//回调
typealias ResponseSuccess = (_ data:Any) ->()
typealias ResponseError = (_ error:Error) ->()

typealias ResponseProgress = (_ process:CGFloat)->()

class BaseUrlReqest: NSObject {
    var isInvalid:Bool = false
    var isInvalidNum:Int = 0
    class var sharedInstance: BaseUrlReqest {
        struct instance {
            static let _instance:BaseUrlReqest = BaseUrlReqest()
        }
        return instance._instance
    }
    //自定义Alamofire.SessionManager.default(设置请求超时时间)
    static let defaultSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30 //30秒
        return Alamofire.SessionManager(configuration: configuration)
    }()
//    request get
    func requestGetWithUrl(_ url: String ,
                           suc: @escaping ResponseSuccess ,
                           err: @escaping ResponseError) {
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        BaseUrlReqest.defaultSessionManager.request(urlStr)
            .responseJSON {response in
                switch response.result{
                case .success(let value):
                    suc(value)
                case .failure(let error):
                    err(error)
                }
        }
    }
//    request post
    func requestPostWithUrl(_ url :String ,
                            param :[String: Any]?,
                            suc :@escaping ResponseSuccess ,
                            err :@escaping ResponseError) {
       
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        BaseUrlReqest.defaultSessionManager.request(urlStr, method: .post, parameters: param).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                suc(value)
            case .failure(let error):
                err(error)
            }
        }
    }
    
    /// - Parameters:
    ///   - url: 下载路径
    ///   - songName: 歌曲、伴奏、歌词名
    ///   - downType: 文件类型
    ///   - pro: 下载进度回调
    ///   - suc: 请求成功回调
    ///   - err: 请求失败回调
    func down(url: String,songName: String, downType: String, pro: @escaping ResponseProgress,suc: @escaping ResponseSuccess, err: @escaping ResponseError){
        
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let manager = FileManager.default
        if !manager.fileExists(atPath: downLoadFile) {
            try! manager.createDirectory(atPath: downLoadFile, withIntermediateDirectories: true, attributes: nil)
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let a: String = String.init(format: "DownLoad/%@.%@", songName,downType)
            let fileURL = documentsURL.appendingPathComponent(a)
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(urlStr, to: destination).downloadProgress { (progress) in
            let a = progress.completedUnitCount
            let b = progress.totalUnitCount
            let pro1: CGFloat = CGFloat(a)/CGFloat(b)
            if downType == "mp3"{
                pro(pro1)
            }
            }.responseData { (data1) in
                switch data1.result{
                case .success(let value):
                    if downType == "mp3"{
                        suc(value)
                    }
                case .failure(let error):
                    if downType == "mp3"{
                        err(error)
                    }
                }
        }
    }
}
