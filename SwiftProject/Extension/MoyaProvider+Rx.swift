//
//  MoyaProvider+Rx.swift
//  DoNewSeas
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation
import Moya
import RxSwift


extension Reactive where Base : MoyaProviderType {
    func request(target:Base.Target,callbackQueue:DispatchQueue? = nil) -> Single<Response> {
        return Single.create {
            [weak base] single in
            let cancelToken = base?.request(target, callbackQueue: callbackQueue, progress: nil, completion: { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                    print(error.errorCode)
                }
            })
            return Disposables.create {
                cancelToken?.cancel()
            }
        }
    }
}

