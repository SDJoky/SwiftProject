//
//  CustomWaterFlowLayout.swift
//  Demo
//
//  Created by Joky on 2019/10/29.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit

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

enum FlowLayoutStyle {
    case styleOfEqualWidth
    case styleOfEqualHeight
}

class WaterfallFlowLayout: UICollectionViewLayout {
    var layoutStyle: FlowLayoutStyle = .styleOfEqualWidth
    weak var layoutDataSource: WaterfallFlowLayoutDataSource?
    // Store layout properties of all cells
    fileprivate var attributesArray = [UICollectionViewLayoutAttributes]()
    // Store maxNumber of per colum
    fileprivate var maxColumHeights = [CGFloat]()
    // Store maxNumber of per row
    fileprivate var maxRowWidths = [CGFloat]()
    // latest content height
    fileprivate var latestColumHeight:CGFloat = 0
    // latest content width
    fileprivate var latestRowWidth:CGFloat = 0
    
    // default colum
    fileprivate var columCount:NSInteger{
        get {
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
    fileprivate var columMargin:CGFloat{
        get{
            return self.layoutDataSource?.columMarginInWaterfallFlowLayout(self) ?? 10
        }
    }
    
    // space between row
    fileprivate var rowMargin:CGFloat{
        get{
            return self.layoutDataSource?.rowMarginInWaterfallFlowLayout(self) ?? 10
        }
    }
    
    // space of edgeInset
    fileprivate var sectionInset:UIEdgeInsets{
        get{
            return self.layoutDataSource?.edgeInsetInWaterfallFlowLayout(self) ?? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    // override
    override func prepare() {
        super.prepare()
        if layoutStyle == .styleOfEqualWidth {
            self.latestColumHeight = 0
            self.maxColumHeights.removeAll()
            for _ in 0..<self.columCount {
                self.maxColumHeights.append(self.sectionInset.top)
            }
        }else if layoutStyle == .styleOfEqualHeight {
            
            // mark last content
            self.latestColumHeight = 0
            self.maxColumHeights.removeAll()
            self.maxColumHeights.append(self.sectionInset.top)
            
            self.latestRowWidth = 0
            self.maxRowWidths.removeAll()
            self.maxRowWidths.append(self.sectionInset.left)
        }
        self.attributesArray.removeAll()
        let sectionsCount = self.collectionView!.numberOfSections
        
        // get per header
        for section in 0..<sectionsCount {
            if let headerSize = self.layoutDataSource?.waterfallFlowLayout(self, sizeForHeaderViewInSection: section), !headerSize.equalTo(CGSize.zero) {
                if let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)){
                    self.attributesArray.append(headerAttributes)
                }
            }
            
            // install  properties of per cell
            let rowsCount = self.collectionView!.numberOfItems(inSection: section)
            var currentRow = 0
            while currentRow < rowsCount {
                let indexPath = IndexPath(item: currentRow, section: section)
                if let itemAttributes = self.layoutAttributesForItem(at: indexPath){
                    self.attributesArray.append(itemAttributes)
                }
                currentRow += 1
            }
            
            //get per group of footer
            if let footerSize = self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: section), !footerSize.equalTo(CGSize.zero) {
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
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if self.layoutStyle == .styleOfEqualWidth {
           attributes.frame = self.itemFrameOfEqualWidthFlowLayout(indexPath)
        }else if self.layoutStyle == .styleOfEqualHeight {
           attributes.frame = self.itemFrameOfEqualHeightFlowLayout(indexPath)
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var layoutAttributes:UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader {
            layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            layoutAttributes?.frame = self.headerViewFrameOfFlowLayout(indexPath)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            layoutAttributes?.frame = self.footerViewFrameOfFlowLayout(indexPath)
        }
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize{
        get {
            if self.layoutStyle == .styleOfEqualWidth {
               return CGSize(width: 0, height: self.latestColumHeight + self.sectionInset.bottom)
            } else if self.layoutStyle == .styleOfEqualHeight {
               return CGSize(width: 0, height: self.latestColumHeight + self.sectionInset.bottom)
            }
            return CGSize.zero
        }
    }
}

extension WaterfallFlowLayout {
    // style of equalWidth
    fileprivate func itemFrameOfEqualWidthFlowLayout(_ indexPath:IndexPath) -> CGRect{
        let viewWidth = self.collectionView!.frame.size.width
        let currentW =  (viewWidth - self.sectionInset.left - self.sectionInset.right - CGFloat(self.columCount - 1) * self.columMargin) / CGFloat(self.columCount)
        let currentH = self.layoutDataSource?.waterfallFlowLayout(self, sizeForItemAtIndexPath: indexPath).height ?? 0
        
        // find min height
        var destColum: NSInteger = 0
        var minColumHeight = self.maxColumHeights.first ?? 0
        for i in 1..<self.columCount{
            let columnHeight = self.maxColumHeights[i]
            if minColumHeight > columnHeight {
                minColumHeight = columnHeight
                destColum = i
            }
        }
        
        let x = self.sectionInset.left + CGFloat(destColum) * (currentW + self.columMargin)
        var y = minColumHeight
        if y != self.sectionInset.top {
            y += self.rowMargin
        }
        
        //update the height of shortest colum
        self.maxColumHeights[destColum] = CGRect(x: x, y: y, width: currentW, height: currentH).maxY
        let columnHeight = self.maxColumHeights[destColum]
        if self.latestColumHeight < columnHeight {
            self.latestColumHeight = columnHeight
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
        } else if (viewW - (self.maxRowWidths.first ?? 0)) == (itemW + self.sectionInset.right) {
            // change line
            x = self.sectionInset.left
            y = (self.maxColumHeights.first ?? 0) + self.rowMargin
            
            self.maxRowWidths[0] = x + itemW
            self.maxColumHeights[0] = y + itemH

        } else {
            // change line
            x = self.sectionInset.left
            y = (self.maxColumHeights.first ?? 0) + self.rowMargin
            self.maxRowWidths[0] = x + itemW
            self.maxColumHeights[0] = y + itemH
        }
        // mark height
        self.latestColumHeight = self.maxColumHeights.first ?? 0
        return CGRect(x: x, y: y, width: itemW, height: itemH)
    }
    
    // return header frame
    fileprivate func headerViewFrameOfFlowLayout(_ indexPath:IndexPath) -> CGRect {
        let size = self.layoutDataSource?.waterfallFlowLayout(self, sizeForHeaderViewInSection: indexPath.section)  ??  CGSize.zero
        if self.layoutStyle == .styleOfEqualWidth {
            let x: CGFloat = 0
            var y: CGFloat = self.latestColumHeight == 0 ? self.sectionInset.top : self.latestColumHeight
            if self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: indexPath.section).height == 0 {
                y = self.latestColumHeight == 0 ? self.sectionInset.top : self.latestColumHeight + self.rowMargin
            }
            self.latestColumHeight = y + size.height
            self.maxColumHeights.removeAll()
            for _ in 0..<self.columCount {
                self.maxColumHeights.append(self.latestColumHeight)
            }
            return CGRect(x: x, y: y, width: self.collectionView!.frame.size.width, height: size.height)
        } else if self.layoutStyle == .styleOfEqualHeight {
            let x: CGFloat = 0
            var y: CGFloat = self.latestColumHeight == 0 ? self.sectionInset.top : self.latestColumHeight
            if self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: indexPath.section).height == 0 {
                y = self.latestColumHeight == 0 ? self.sectionInset.top : self.latestColumHeight + self.rowMargin
            }
            self.latestColumHeight = y + size.height
            self.maxRowWidths[0] = self.collectionView!.frame.size.width
            
            self.maxColumHeights[0] = self.latestColumHeight
            
            return CGRect(x: x, y: y, width: self.collectionView!.frame.size.width, height: size.height)
        }
        return CGRect.zero
    }
    
    //return footer frame
    fileprivate func footerViewFrameOfFlowLayout(_ indexPath:IndexPath) -> CGRect{
        let size = self.layoutDataSource?.waterfallFlowLayout(self, sizeForFooterViewInSection: indexPath.section)  ??  CGSize.zero
        if self.layoutStyle == .styleOfEqualWidth {
            let x: CGFloat = 0
            let y: CGFloat = size.height == 0 ? self.latestColumHeight : self.latestColumHeight + self.rowMargin
            self.latestColumHeight = y + size.height
            self.maxColumHeights.removeAll()
            for _ in 0..<self.columCount {
                self.maxColumHeights.append(self.latestColumHeight)
            }
            return CGRect(x: x, y: y, width: self.collectionView!.frame.size.width, height: size.height)
        }else if self.layoutStyle == .styleOfEqualHeight {
            let x: CGFloat = 0
            let y: CGFloat = size.height == 0 ? self.latestColumHeight : self.latestColumHeight + self.rowMargin
            self.latestColumHeight = y + size.height
            
            self.maxRowWidths[0] = self.collectionView!.frame.size.width
            self.maxColumHeights[0] = self.latestColumHeight
            return CGRect(x: x, y: y, width: self.collectionView!.frame.size.width, height: size.height)
        }
        return CGRect.zero
    }
}

