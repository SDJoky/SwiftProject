//
//  ThemeVM.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class ThemeVM{
    
    let data = BehaviorRelay<[ZHNewsModel]>(value: [])
    
    func loadData(endFreshBinder:Binder<Bool>,
                  disposeBag: DisposeBag) {
        
        provider.rx.request(.getNewsList)
                   .asObservable()
                   .mapModel(ZHNewsModel.self)
                   .subscribe(onNext: { (model) in
                    self.data.accept([ZHNewsModel.init(original: model, items: model.stories)])
                    SVProgressHUD.showSuccess(withStatus: "请求成功")
                   }).disposed(by: disposeBag)
        self.data.map{ _ in true }.bind(to: endFreshBinder).disposed(by: disposeBag)

    }
               
}
