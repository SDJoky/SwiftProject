//
//  ThemeVM.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation

class ThemeVM{
    private var date: String = ""
    
    let data = BehaviorRelay<[ZHNewsModel]>(value: [])
//    下拉刷新
    func loadData(endFreshBinder:Binder<Bool>,
                  disposeBag: DisposeBag) {
        
        provider.rx.request(.getNewsList)
                   .asObservable()
                   .mapModel(ZHNewsModel.self)
                   .subscribe(onNext: { (model) in
                    self.data.accept([ZHNewsModel.init(original: model, items: model.stories)])
                    self.date = model.date
                    SVProgressHUD.showSuccess(withStatus: "请求成功")
                   }).disposed(by: disposeBag)
        self.data.map{ _ in true }.bind(to: endFreshBinder).disposed(by: disposeBag)

    }
    
//    上拉加载
    func loadMoreData(endFreshBinder:Binder<Bool>,
    disposeBag: DisposeBag) {
        
        provider.rx.request(.getMoreNews(self.date))
                   .asObservable()
                   .mapModel(ZHNewsModel.self)
                   .subscribe(onNext:{ (model) in
                    self.date = model.date
                    self.data.accept(self.data.value + [ZHNewsModel.init(original: model, items: model.stories)])
                   }).disposed(by: disposeBag)
        
        self.data.map{ _ in true }.bind(to: endFreshBinder).disposed(by: disposeBag)
        
    }
               
}
