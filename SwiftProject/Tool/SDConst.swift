//
//  SDConst.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/17.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit
@_exported import RxSwift
@_exported import Moya
@_exported import RxDataSources
@_exported import SVProgressHUD
@_exported import RxCocoa
@_exported import MJRefresh
@_exported import SnapKit

/// 屏幕的宽
let SCREENW = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREENH = UIScreen.main.bounds.size.height

let PATH_OF_CACHE = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let PATH_OF_DOCUMENT = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let PATH_OF_LIBRARY = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

let downLoadFile = PATH_OF_DOCUMENT + "/DownLoad"


