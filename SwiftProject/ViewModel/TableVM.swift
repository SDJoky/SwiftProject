//
//  TableVM.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/8.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

enum TableRefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class TableVM: NSObject {
    let models = Variable<[DataModel]>([])
    var index : Int = 1
}

extension TableVM : VMProtocol {
    
    
    //    为已经存在的类型重新定义名字的
    typealias Input = DataInput
    
    typealias Output = DataOutput
    
    struct DataInput {
        let category : LXFNetworkTool.LXFNetworkCategory
        init(category : LXFNetworkTool.LXFNetworkCategory) {
            self.category = category
        }
        
    }
    
    struct DataOutput {
        let sections : Driver<[DataSection]>
//        加载数据
        let requestCommand = PublishSubject<Bool>()
        let refreshStaus = Variable<TableRefreshStatus>(.none)
        init(sections: Driver<[DataSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: TableVM.DataInput) -> TableVM.DataOutput {
        let sections = models.asObservable().map { (models) -> [DataSection] in
            return[DataSection(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = DataOutput(sections: sections)
        output.requestCommand.subscribe(onNext: {[unowned self] isReloadData in
            self.index = isReloadData ? 1 : self.index+1
            lxfNetTool.rx.request(.data(type: input.category, size: 10, index: self.index))
                .asObservable()
                .mapArray(DataModel.self)
                .subscribe({ [weak self] (event) in
                    switch event {
                    case let .next(modelArr):
                        self?.models.value = isReloadData ? modelArr : (self?.models.value ?? []) + modelArr
                        SVProgressHUD.showSuccess(withStatus: "请求成功")
                        print(modelArr)
                    case let .error(error):
                        SVProgressHUD.showError(withStatus:error.localizedDescription)
                    case .completed:
                        output.refreshStaus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                    }
                }).disposed(by: self.rx.disposeBag)
        }).disposed(by : rx.disposeBag)
        
        return output
    }
}
