//
//  CustomWaterFlowLayout.swift
//  Demo
//
//  Created by Joky on 2019/10/29.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit

enum FlowLayoutStyle {
    case styleOfEqualWidth
    case styleOfEqualHeight
}

protocol WaterfallFlowLayoutDataSource: class {
    // caculate itemSize
    func waterfallFlowLayout(_ layout : WaterfallFlowLayout, sizeForItemAtIndexPath indexPath : IndexPath) -> CGSize
    
    // config header size
    func waterfallFlowLayout(_ layout : WaterfallFlowLayout, sizeForHeaderViewInSection section: NSInteger) -> CGSize
    
    // config footer size
    func waterfallFlowLayout(_ layout : WaterfallFlowLayout, sizeForFooterViewInSection section: NSInteger) -> CGSize
    
    // number of colum
    func columCountInWaterfallFlowLayout(_ layout : WaterfallFlowLayout) -> NSInteger
    
    // number of row
    func rowCountInWaterfallFlowLayout(_ layout : WaterfallFlowLayout) -> NSInteger
    
    // margin of colum
    func columMarginInWaterfallFlowLayout(_ layout : WaterfallFlowLayout) -> CGFloat
    
    // margin of row
    func rowMarginInWaterfallFlowLayout(_ layout : WaterfallFlowLayout) -> CGFloat
    
    // edgeInset from superView
    func edgeInsetInWaterfallFlowLayout(_ layout : WaterfallFlowLayout) -> UIEdgeInsets
}

class WaterfallFlowLayout: UICollectionViewLayout{
    var layoutStyle: FlowLayoutStyle = .styleOfEqualWidth
    weak var layoutDataSource: WaterfallFlowLayoutDataSource?
    // Store layout properties of all cells
    fileprivate var attributesArray = [UICollectionViewLayoutAttributes]()
    // Store maxNumber of per colum
    fileprivate var maxColumHeights = [CGFloat]()
    // Store maxNumber of per row
    fileprivate var maxRowWidths = [CGFloat]()
    // latest content height
    fileprivate var currentMaxColumHeight:CGFloat = 0
    // latest content width
    fileprivate var latestRowWidth:CGFloat = 0
    
    // default colum
    fileprivate var columCount:NSInteger {
        get{
            return self.layoutDataSource?.columCountInWaterfallFlowLayout(self) ?? 2
        }
    }
    
    // default row
    fileprivate var rowCount:NSInteger {
        get{
            return self.layoutDataSource?.rowCountInWaterfallFlowLayout(self) ?? 2
        }
    }
    
    // space between colum
    fileprivate var columMargin:CGFloat {
        get{
            return self.layoutDataSource?.columMarginInWaterfallFlowLayout(self) ?? 10
        }
    }
    
    // space between row
    fileprivate var rowMargin:CGFloat {
        get{
            return self.layoutDataSource?.rowMarginInWaterfallFlowLayout(self) ?? 10
        }
    }
    
    // space of edgeInset
    fileprivate var sectionInset:UIEdgeInsets {
        get{
            return self.layoutDataSource?.edgeInsetInWaterfallFlowLayout(self) ?? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    // override
    override func prepare() {
        super.prepare()
        if layoutStyle == .styleOfEqualWidth {
            self.currentMaxColumHeight = 0
            self.maxColumHeights.removeAll()
            for _ in 0..<self.columCount {
                self.maxColumHeights.append(self.sectionInset.top)
            }
        } else if layoutStyle == .styleOfEqualHeight {
            
            // mark lastest content
            self.currentMaxColumHeight = 0
            self.maxColumHeights.removeAll()
            self.maxColumHeights.append(self.sectionInset.top)
            
            self.latestRowWidth = 0
            self.maxRowWidths.removeAll()
            self.maxRowWidths.append(self.sectionInset.left)
        }
        self.attributesArray.removeAll()
        let sectionNum = self.collectionView!.numberOfSections
        
        // get per section's information
        for section in 0..<sectionNum {
            
            if let headerSize = self.layoutDataSource?.waterfallFlowLayout(self, sizeForHeaderViewInSection: section), !headerSize.equalTo(CGSize.zero){
                // add header attribute
                if let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
                    
                    self.attributesArray.append(headerAttributes)
                }
            }
            
            // install  properties of per cell
            let rowsNum = self.collectionView!.numberOfItems(inSection: section)
            var currentRow = 0
            while currentRow < rowsNum {
                let indexPath = IndexPath(item: currentRow, section: section)
                // add row attribute
                if let itemAttribute = self.layoutAttributesForItem(at: indexPath){
                    self.attributesArray.append(itemAttribute)
                }
                currentRow += 1
            }
            
            //get per group of footer
            if let footerSize = self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: section), !footerSize.equalTo(CGSize.zero) {
                //add footer attribute
                if let footerAttribute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section)){
                    self.attributesArray.append(footerAttribute)
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if self.layoutStyle == .styleOfEqualWidth {
           attribute.frame = self.itemFrameOfEqualWidthFlowLayout(indexPath)
        }else if self.layoutStyle == .styleOfEqualHeight {
           attribute.frame = self.itemFrameOfEqualHeightFlowLayout(indexPath)
        }
        return attribute
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var layoutAttributes:UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader {
            layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            layoutAttributes?.frame = self.obtainSupplementaryFrameWithHeaderOrFooter(indexPath, true)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            layoutAttributes?.frame = self.obtainSupplementaryFrameWithHeaderOrFooter(indexPath, false)
        }
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize{
        get {
            return CGSize(width: self.collectionView!.frame.size.width, height: self.currentMaxColumHeight + self.sectionInset.bottom)
        }
    }
}

extension WaterfallFlowLayout {
    // style of equalWidth
    fileprivate func itemFrameOfEqualWidthFlowLayout(_ indexPath:IndexPath) -> CGRect{
        let viewWidth = self.collectionView!.frame.size.width
        // caculate item width
        let currentW =  (viewWidth - self.sectionInset.left - self.sectionInset.right - CGFloat(self.columCount - 1) * self.columMargin) / CGFloat(self.columCount)
        let currentH = self.layoutDataSource?.waterfallFlowLayout(self, sizeForItemAtIndexPath: indexPath).height ?? 0
        
        // find all colums' min height
        var destColum: NSInteger = 0
        var minColumHeight = self.maxColumHeights.first ?? 0
        for i in 1..<self.columCount{
            let columnHeight = self.maxColumHeights[i]
            if minColumHeight > columnHeight {
                minColumHeight = columnHeight
                destColum = i
            }
        }
        // put new item at min colum
        let x = self.sectionInset.left + CGFloat(destColum) * (currentW + self.columMargin)
        var y = minColumHeight
        if y != self.sectionInset.top {
            y += self.rowMargin
        }
        
        //update the height of shortest colum
        self.maxColumHeights[destColum] = CGRect(x: x, y: y, width: currentW, height: currentH).maxY
        let columnHeight = self.maxColumHeights[destColum]
        if self.currentMaxColumHeight < columnHeight {
            self.currentMaxColumHeight = columnHeight
        }
        return CGRect(x: x, y: y, width: currentW, height: currentH)
    }
    
    // style of equalHeight
    fileprivate func itemFrameOfEqualHeightFlowLayout(_ indexPath:IndexPath) -> CGRect{
        let viewW = self.collectionView!.frame.size.width
        
        let headerSize = self.layoutDataSource?.waterfallFlowLayout(self, sizeForHeaderViewInSection: indexPath.section) ?? CGSize.zero

        let itemW =  self.layoutDataSource?.waterfallFlowLayout(self, sizeForItemAtIndexPath: indexPath).width ?? 0
        let itemH = self.layoutDataSource?.waterfallFlowLayout(self, sizeForItemAtIndexPath: indexPath).height ?? 0
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        // mark final row
        if (viewW - (self.maxRowWidths.first ?? 0)) > viewW + self.sectionInset.right {
            x = self.maxRowWidths.first == self.sectionInset.left ?  self.sectionInset.left : ((self.maxRowWidths.first ?? 0) + self.columMargin)
            // config y
            if (self.maxColumHeights.first ?? 0) == self.sectionInset.top {
                y = self.sectionInset.top
            } else if (self.maxColumHeights.first ?? 0) == self.sectionInset.top + headerSize.height {
                y =  self.sectionInset.top + headerSize.height + self.rowMargin
            } else {
                let ch = (self.maxColumHeights.first ?? 0) - itemH
                y = ch > 0 ? ch : 0
            }
            self.maxRowWidths[0] = x + viewW
            if self.maxColumHeights.first == self.sectionInset.top || self.maxColumHeights.first == self.sectionInset.top + headerSize.height {
                self.maxColumHeights[0] = y + itemH
            }
        } else {
            // change line
            x = self.sectionInset.left
            y = (self.maxColumHeights.first ?? 0) + self.rowMargin
            self.maxRowWidths[0] = x + itemW
            self.maxColumHeights[0] = y + itemH
        }
        // mark height
        self.currentMaxColumHeight = self.maxColumHeights.first ?? 0
        return CGRect(x: x, y: y, width: itemW, height: itemH)
    }
    
    /// update max number of colum and row with section
    /// - Parameter indexPath: indexPath
    /// - Parameter isHeader: section of header yes or no
    fileprivate func obtainSupplementaryFrameWithHeaderOrFooter(_ indexPath: IndexPath, _ isHeader: Bool) -> CGRect {
        var size = CGSize.zero
        var y: CGFloat = 0
        if  isHeader {
            size = self.layoutDataSource?.waterfallFlowLayout(self, sizeForHeaderViewInSection: indexPath.section)  ??  CGSize.zero
            if self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: indexPath.section).height == 0 {
                y = self.currentMaxColumHeight == 0 ? self.sectionInset.top : self.currentMaxColumHeight + self.rowMargin
            } else {
                y = self.currentMaxColumHeight == 0 ? self.sectionInset.top : self.currentMaxColumHeight
            }
            self.currentMaxColumHeight = y + size.height
        } else {
            size = self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: indexPath.section)  ??  CGSize.zero
            y = size.height == 0 ? self.currentMaxColumHeight : self.currentMaxColumHeight + self.rowMargin
            self.currentMaxColumHeight = y + size.height
        }
        
        if self.layoutStyle == .styleOfEqualWidth {
            self.maxColumHeights.removeAll()
            for _ in 0..<self.columCount {
                self.maxColumHeights.append(self.currentMaxColumHeight)
            }
        } else if self.layoutStyle == .styleOfEqualHeight {
            
            self.maxRowWidths[0] = self.collectionView!.frame.size.width
            self.maxColumHeights[0] = self.currentMaxColumHeight
            
        } else {
            return CGRect.zero
        }
        return CGRect(x: 0, y: y, width: self.collectionView!.frame.size.width, height: size.height)
    }
}


