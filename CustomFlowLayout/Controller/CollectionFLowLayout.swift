//
//  CollectionFLowLayout.swift
//  CollectionViewAutoLayout
//
//  Created by iOS Developer on 20/04/18.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView:UICollectionView, widthForItem width:CGFloat, heightForItemAt indexPath:IndexPath) -> CGFloat
}

class CollectionFLowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Variables
    
    // Configurable properties
    var numberOfColumns = 2
    
    // Layout Delegate
    weak var delegate: CollectionViewLayoutDelegate!
    
    // Array to keep a cache of attributes.
    var itemAttributes = [UICollectionViewLayoutAttributes]()
    
    // Private variable
    // Content width, height and size
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.size.width, height: contentHeight)
    }

    // MARK: - Default Methods
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let itemWidth = (UIScreen.main.bounds.size.width - (CGFloat(numberOfColumns + 1) * self.minimumInteritemSpacing)) / CGFloat(numberOfColumns)
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    // MARK: - Override UICollectionViewLayout Methods
    override func prepare() {
        // Calculate once
        guard itemAttributes.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let minimumLineSpacing = minimumLineSpacingForSectionAt(section: 0)
        let minimumInteritemSpacing = minimumInteritemSpacingForSectionAt(section: 0)
        let sectionInset = insetForSectionAt(section: 0)
        
        let cellPadding: CGFloat = 10
        let columnWidth = (contentWidth - sectionInset.left - sectionInset.right) / CGFloat(numberOfColumns)
        let cellWidth = columnWidth - minimumInteritemSpacing * CGFloat(numberOfColumns - 1) / CGFloat(numberOfColumns)
        let width = cellWidth - cellPadding
        
        contentHeight = 0
        contentHeight += sectionInset.top;
        
        var columnHeights = [CGFloat](repeating: 0, count: numberOfColumns)
        for i in 0 ..< numberOfColumns {
            columnHeights[i] = contentHeight
        }
        
        let itemCount: Int = collectionView.numberOfItems(inSection: 0)
        // Iterates through the list of items in the first section
        for i in 0 ..< itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let columnIndex = columnHeights.index(of: columnHeights.min()!)
            // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            var height = delegate.collectionView(collectionView, widthForItem: width, heightForItemAt: indexPath)
            let xOffset = sectionInset.left + (cellWidth + minimumInteritemSpacing) * CGFloat(columnIndex!)
            height = height + cellPadding
            let frame = CGRect(x: xOffset, y: columnHeights[columnIndex!], width: cellWidth, height: height)
            // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            itemAttributes.append(attributes)
            columnHeights[columnIndex!] = attributes.frame.maxY + minimumLineSpacing
        }
        
        // Updates the collection view content height
        contentHeight = columnHeights.max()!
        if itemCount == 0 {
            contentHeight += UIScreen.main.bounds.size.height
        }
        contentHeight += sectionInset.bottom;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes in itemAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    // MARK: - Methods to get your layout settings
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        if delegate.responds(to: #selector(delegate.collectionView(_:layout:insetForSectionAt:))) {
            return delegate.collectionView!((collectionView)!, layout: self, insetForSectionAt: section)
        }
        else {
            return self.sectionInset
        }
    }
    
    func minimumInteritemSpacingForSectionAt(section: Int) -> CGFloat {
        if delegate.responds(to: #selector(delegate.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) {
            return delegate.collectionView!((collectionView)!, layout: self, minimumInteritemSpacingForSectionAt: section)
        }
        else {
            return self.minimumLineSpacing
        }
    }
    
    func minimumLineSpacingForSectionAt(section: Int) -> CGFloat {
        if delegate.responds(to: #selector(delegate.collectionView(_:layout:minimumLineSpacingForSectionAt:))) {
            return delegate.collectionView!((collectionView)!, layout: self, minimumLineSpacingForSectionAt: section)
        }
        else {
            return self.minimumLineSpacing
        }
    }
    
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        if delegate.responds(to: #selector(delegate.collectionView(_:layout:sizeForItemAt:))) {
            return delegate.collectionView!((collectionView)!, layout: self, sizeForItemAt: indexPath)
        }
        else {
            return self.itemSize
        }
    }
}
