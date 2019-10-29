//
//  FlowLayoutViewController.swift
//  Demo
//
//  Created by Joky on 2019/10/29.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit

class FlowLayoutViewController: UIViewController {
    var collectionView: UICollectionView!
    var itemHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<10 {
            itemHeights.append(CGFloat(arc4random() % 80 + arc4random() % 30))
        }
        view.backgroundColor = UIColor.red
        let layout = WaterfallFlowLayout()
        layout.layoutStyle = .styleOfEqualWidth
        layout.layoutDataSource = self
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        self.collectionView.register(FlowCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        self.collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        self.collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "sectionFooter")
        
    }
    
}

// mark --- CollectionViewDelegate
extension FlowLayoutViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemHeights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sectionHeader", for: indexPath)
            headerView.backgroundColor = UIColor.yellow
            return headerView
        }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "sectionFooter", for: indexPath)
        footerView.backgroundColor = UIColor.systemPink
        return footerView
    }
}
// mark --- WaterfallFlowLayoutDataSource
extension FlowLayoutViewController: WaterfallFlowLayoutDataSource{
    func waterfallFlowLayout(_ layout: WaterfallFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width:0, height:itemHeights[indexPath.row] )
    }
    
    func waterfallFlowLayout(_ layout: WaterfallFlowLayout, sizeForHeaderViewInSection section: NSInteger) -> CGSize {
         return CGSize(width: 0, height: 20)
    }
    
    func waterfallFlowLayout(_ layout: WaterfallFlowLayout, sizeForFooterViewInSection section: NSInteger) -> CGSize {
         return CGSize(width: 0, height: 40)
    }
    
    func columCountInWaterfallFlowLayout(_ layout: WaterfallFlowLayout) -> NSInteger {
        return 2
    }
    
    func rowCountInWaterfallFlowLayout(_ layout: WaterfallFlowLayout) -> NSInteger {
        return 10
    }
    
    func columMarginInWaterfallFlowLayout(_ layout: WaterfallFlowLayout) -> CGFloat {
        return 10
    }
    
    func rowMarginInWaterfallFlowLayout(_ layout: WaterfallFlowLayout) -> CGFloat {
        return 10
    }
    
    func edgeInsetInWaterfallFlowLayout(_ layout: WaterfallFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    
}
