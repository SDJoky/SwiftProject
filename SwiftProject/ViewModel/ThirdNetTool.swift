//
//  ThirdNetTool.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/10.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//


import UIKit

let lxfNetTool = MoyaProvider<ThirdNetTool>()
enum ThirdNetTool {
    enum LXFNetworkCategory: String {
        case ios     = "iOS"
        case welfare = "福利"
    }
    
    case data(type: LXFNetworkCategory, size:Int, index:Int)
}

extension ThirdNetTool : TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "http://gank.io/api/data/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .data(let type, let size, let index):
            return "\(type.rawValue)/\(size)/\(index)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "LinXunFeng".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .requestPlain
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}

