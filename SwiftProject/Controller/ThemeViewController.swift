//
//  ThemeViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/8/1.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    private let dispose = DisposeBag()
    private let viewModel: ThemeVM = ThemeVM()
    private var tableView: UITableView! = nil
    private var doubleClick: Bool = false
    private let testStr = "现在，最近发现的GitHub驱动程序页面列出了两种完全未知的ThinkPad X1设备，即ThinkPad X1 Nano和ThinkPad X1 Next。目前，我们对这些设备一无所知，无论是定位，规格还是价格。自然地，这留下了一些推测的空间。"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindView()
        title = "RxSwift"
    }
    
}

extension ThemeViewController {
    fileprivate func setupUI() {
        view.backgroundColor = .red
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        tableView.rowHeight = TestTableViewCell.cellHeigh()
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).offset(0);
        }
        tableView.tableHeaderView = UIView()
    }
    
//    数据绑定操作
    fileprivate func bindView() {
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: dispose)

        let dataSource = RxTableViewSectionedReloadDataSource<ZHNewsModel>(
            
            configureCell: {[weak self] ds,tv,ip,item in
                
                let cell : TestTableViewCell = tv.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: ip) as! TestTableViewCell
                cell.desLbl.text = "标题: \(item.title)"
                cell.desLbl.textColor = UIColor.black
                cell.nameLbl.text = "描述:\(item.hint)"
                cell.nameLbl.textColor = UIColor.orange
                if item.images.count > 0 {
                    cell.photoImgV.kf.setImage(with: URL(string: item.images[0]))
                    cell.photoImgV.layer.cornerRadius = 10
                } else {
                    cell.photoImgV.layer.cornerRadius = 0
                }

                if ip.row == 0,ip.section == 0 {
                    cell.testLable.text = self!.doubleClick ? self?.testStr : "1"
                } else {
                    cell.testLable.text = ""
                }
                return cell
        },
            //        设置分区头
            titleForHeaderInSection: { ds,index in
                return "时间为：\(ds.sectionModels[index].date)"
            })
            
//        数据绑定
        viewModel.data
            .asObservable()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: dispose)
        
//        下拉刷新
        tableView.mj_header = MJRefreshGifHeader()
        tableView.mj_header
            .rx
            .refreshing
            .subscribe({ [weak self](e) in
            self?.viewModel.loadData(endFreshBinder: self!.tableView.rx.endRefresh, disposeBag: self!.dispose)

        }).disposed(by: self.dispose)
        
//        上拉加载
        tableView.mj_footer = MJRefreshAutoGifFooter()
        tableView.mj_footer
            .rx
            .refreshing
            .subscribe({ [weak self](e) in
            self?.viewModel.loadMoreData(endFreshBinder: self!.tableView.rx.endRefresh, disposeBag: self!.dispose)
        }).disposed(by: self.dispose)
        
//        选中某行
//        tableView.rx
//            .modelSelected(StoryModel.self)
//            .subscribe(onNext: { (model) in
//                SVProgressHUD.showInfo(withStatus: model.hint)
//            }).disposed(by: dispose)
        
        tableView.mj_header.beginRefreshing()

    }
    
}

extension ThemeViewController: UITableViewDelegate {
    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0,indexPath.section == 0 {
            return doubleClick ? 150 + 10 + getTextHeightWithText(content: testStr): 150 + 10 + getTextHeightWithText(content: "1")
        } else {
            return 150
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doubleClick = !doubleClick
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func getTextHeightWithText(content:String) -> CGFloat
    {
        let paragraphStyle:NSMutableParagraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        let options = unsafeBitCast(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.usesFontLeading.rawValue,
                                    to: NSStringDrawingOptions.self)
        let boundingRect = content.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width-20, height: 0), options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.paragraphStyle:paragraphStyle], context: nil)
        return boundingRect.size.height

    }
    
}

