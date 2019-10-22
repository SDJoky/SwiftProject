//
//  ApiManager.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation
import Moya

let provider = MoyaProvider<ApiManager>()

enum ApiManager {
//    接口信息
    case getNewsList
}

extension ApiManager : TargetType {
  
    var path: String {
        switch self {
        case .getNewsList:
            return "4/news/latest"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    //做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var baseURL: URL {
        return URL(string: "http://news-at.zhihu.com/api")!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    //请求头 以JSONEncoding.default  形式的请求  JSONEncoding类型创建了一个参数对象的JOSN展示，并作为请求体。编码请求的请求头的Content-Type请求字段被设置为application/json; charset=utf-8
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
}
