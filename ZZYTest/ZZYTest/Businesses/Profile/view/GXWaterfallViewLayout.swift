
import UIKit

@objc public protocol GXWaterfallViewLayoutDelegate: NSObjectProtocol {
    func size(layout: GXWaterfallViewLayout, indexPath: IndexPath, itemSize: CGFloat) -> CGFloat
    @objc optional func moveItem(at sourceIndexPath:IndexPath, toIndexPath:IndexPath)
}

public class GXWaterfallViewLayout: UICollectionViewLayout {
    public var numberOfColumns: Int = 3
    public var lineSpacing: CGFloat = 0
    public var interitemSpacing: CGFloat = 0
    public var headerSize: CGFloat = 0
    public var footerSize: CGFloat = 0
    public var sectionInset: UIEdgeInsets = .zero
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    public weak var delegate: GXWaterfallViewLayoutDelegate?
    public var shouldAnimations: Array<IndexPath> = []
    
    private var cellLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var headLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var footLayoutInfo: Dictionary<IndexPath, UICollectionViewLayoutAttributes> = [:]
    private var maxScrollDirPositionForColumn: Dictionary<Int, CGFloat> = [:]
    private var startScrollDirPosition: CGFloat = 0
}

public extension GXWaterfallViewLayout {
    
    override func prepare() {
        super.prepare()
        
        self.cellLayoutInfo.removeAll()
        self.headLayoutInfo.removeAll()
        self.footLayoutInfo.removeAll()
        self.maxScrollDirPositionForColumn.removeAll()
        
        switch self.scrollDirection {
        case .vertical:
            self.prepareLayoutAtScrollDirectionVertical()
        case .horizontal:
            self.prepareLayoutAtScrollDirectionHorizontal()
        @unknown default:
            fatalError("unknown scrollDirection.")
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes: Array<UICollectionViewLayoutAttributes> = Array()
        for attributes in self.cellLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        for attributes in self.headLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        for attributes in self.footLayoutInfo.values {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cellLayoutInfo[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return self.headLayoutInfo[indexPath]
        }
        else if elementKind == UICollectionView.elementKindSectionFooter {
            return self.footLayoutInfo[indexPath]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        guard self.collectionView != nil else { return .zero }
        
        let width = self.collectionView!.frame.width - self.collectionView!.contentInset.left - self.collectionView!.contentInset.right
        let height = self.collectionView!.frame.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        switch self.scrollDirection {
        case .vertical:
            return CGSize(width: width, height: max(self.startScrollDirPosition, height))
        case .horizontal:
            return CGSize(width: max(self.startScrollDirPosition, width), height: height)
        @unknown default:
            fatalError("unknown scrollDirection.")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard self.collectionView != nil else { return false }
        if self.collectionView!.bounds.size.equalTo(newBounds.size) {
            return true
        }
        return false
    }
    
    // ?????????updateAction?????????????????????????????????????????????????????????
    override func finalizeCollectionViewUpdates() {
        self.shouldAnimations.removeAll()
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        var indexPaths: Array<IndexPath> = []
        for item in updateItems {
            switch item.updateAction {
            case .insert:
                if item.indexPathAfterUpdate != nil {
                    indexPaths.append(item.indexPathAfterUpdate!)
                }
            case .delete:
                if item.indexPathBeforeUpdate != nil {
                    indexPaths.append(item.indexPathBeforeUpdate!)
                }
            case .move, .reload:
                if item.indexPathBeforeUpdate != nil {
                    indexPaths.append(item.indexPathBeforeUpdate!)
                }
                if item.indexPathAfterUpdate != nil {
                    indexPaths.append(item.indexPathAfterUpdate!)
                }
            default: break
            }
        }
        self.shouldAnimations.append(contentsOf: indexPaths)
    }

    // ??????UICollectionViewUpdateItem ???indexPathBeforeUpdate ????????????
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        guard attributes != nil else { return nil }
        if self.shouldAnimations.contains(itemIndexPath) {
            attributes?.center = CGPoint(x: self.collectionView!.bounds.midX, y: self.collectionView!.bounds.midY)
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes?.alpha = 0.1
            self.shouldAnimations.removeAll { (indexPath) -> Bool in
                return itemIndexPath == indexPath
            }
        }
        return attributes
    }
    
    // ??????UICollectionViewUpdateItem ???indexPathAfterUpdate ????????????
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        guard attributes != nil else { return nil }
        if self.shouldAnimations.contains(itemIndexPath) {
            attributes?.center = CGPoint(x: self.collectionView!.bounds.midX, y: self.collectionView!.bounds.midY)
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes?.alpha = 0.1
            self.shouldAnimations.removeAll { (indexPath) -> Bool in
                return itemIndexPath == indexPath
            }
        }
        return attributes
    }
    
    override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        if self.delegate != nil {
            if self.delegate!.responds(to: #selector(self.delegate!.moveItem(at:toIndexPath:))) {
                self.delegate?.moveItem?(at: previousIndexPaths.first!, toIndexPath: targetIndexPaths.first!)
            }
        }
        return context
    }
}

fileprivate extension GXWaterfallViewLayout {
    
    func prepareLayoutAtScrollDirectionVertical() {
        guard self.collectionView?.dataSource != nil else { return }
        
        // CollectionView content width
        let contentWidth: CGFloat = self.collectionView!.frame.width - self.collectionView!.contentInset.left - self.collectionView!.contentInset.right
        // Section content width
        let sectionContentWidth: CGFloat = contentWidth - self.sectionInset.left - self.sectionInset.right
        // cell width
        let itemWidth: CGFloat = floor((sectionContentWidth - self.interitemSpacing*CGFloat(self.numberOfColumns - 1))/CGFloat(self.numberOfColumns))
        // Start point y
        self.startScrollDirPosition = 0.0
        
        // Section attributes
        let sectionCount: Int = self.collectionView!.numberOfSections
        let respondsSupplementary: Bool = self.collectionView!.responds(to: #selector(self.collectionView!.supplementaryView(forElementKind:at:)))
        
        for section in 0..<sectionCount {
            // Haders layout
            if self.headerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                attributes.frame = CGRect(x: 0, y: self.startScrollDirPosition, width: contentWidth, height: self.headerSize)
                self.headLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.headerSize + self.sectionInset.top
            }
            else {
                self.startScrollDirPosition += self.sectionInset.top
            }
            
            // Set first section cells point y
            for row in 0..<self.numberOfColumns {
                self.maxScrollDirPositionForColumn[row] = self.startScrollDirPosition
            }
            
            // Cells layout
            let rowCount: Int = self.collectionView!.numberOfItems(inSection: section)
            for row in 0..<rowCount {
                let indexPath = IndexPath(row: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // ??????????????????cell?????????????????????????????????????????????????????????
                var top: CGFloat = self.maxScrollDirPositionForColumn[0]!
                var currentRow: Int = 0
                for i in 1..<self.numberOfColumns {
                    let iTop: CGFloat = self.maxScrollDirPositionForColumn[i]!
                    if iTop < top {
                        top = iTop; currentRow = i
                    }
                }
                let left = self.sectionInset.left + (self.interitemSpacing + itemWidth) * CGFloat(currentRow)
                let itemHeight: CGFloat = self.delegate?.size(layout: self, indexPath: indexPath, itemSize: itemWidth) ?? 0
                attributes.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
                self.cellLayoutInfo[indexPath] = attributes
                // ????????????????????????Y????????????????????????cell?????????cell?????????
                top += self.lineSpacing + itemHeight
                self.maxScrollDirPositionForColumn[currentRow] = top
                //??????section???????????????cell?????????????????????cell?????????X????????????startScrollDirPosition(??????X??????)?????????????????????????????????X???
                if row == (rowCount - 1) {
                    var maxTop: CGFloat = self.maxScrollDirPositionForColumn[0]!
                    for i in 1..<self.numberOfColumns {
                        let iTop: CGFloat = self.maxScrollDirPositionForColumn[i]!
                        if iTop > maxTop {
                            maxTop = iTop
                        }
                    }
                    // ?????????cell?????????cell???Y?????????????????????????????????cell???????????????cell??????
                    self.startScrollDirPosition = maxTop - self.lineSpacing + self.sectionInset.bottom
                }
            }
            
            // Footers layout
            if self.footerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                attributes.frame = CGRect(x: 0, y: self.startScrollDirPosition, width: contentWidth, height: self.footerSize)
                self.footLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.footerSize
            }
        }
    }
    
    func prepareLayoutAtScrollDirectionHorizontal() {
        guard self.collectionView?.dataSource != nil else { return }
        
        // CollectionView content height
        let contentHeight: CGFloat = self.collectionView!.frame.height - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
        // Section content height
        let sectionContentHeight: CGFloat = contentHeight - self.sectionInset.top - self.sectionInset.bottom
        // cell height
        let itemHeight: CGFloat = floor((sectionContentHeight - self.lineSpacing*CGFloat(self.numberOfColumns - 1))/CGFloat(self.numberOfColumns))
        // Start point x
        self.startScrollDirPosition = 0.0
        
        // Section attributes
        let sectionCount: Int = self.collectionView!.numberOfSections
        let respondsSupplementary: Bool = self.collectionView!.responds(to: #selector(self.collectionView!.supplementaryView(forElementKind:at:)))
        
        for section in 0..<sectionCount {
            // Haders layout
            if self.headerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                attributes.frame = CGRect(x: self.startScrollDirPosition, y: 0, width: self.headerSize, height: contentHeight)
                self.headLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.headerSize + self.sectionInset.left
            }
            else {
                self.startScrollDirPosition += self.sectionInset.left
            }
            
            // Set first section cells point x
            for row in 0..<self.numberOfColumns {
                self.maxScrollDirPositionForColumn[row] = self.startScrollDirPosition
            }
            
            // Cells layout
            let rowCount: Int = self.collectionView!.numberOfItems(inSection: section)
            for row in 0..<rowCount {
                let indexPath = IndexPath(row: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // ??????????????????cell?????????????????????????????????????????????????????????
                var left: CGFloat = self.maxScrollDirPositionForColumn[0]!
                var currentRow: Int = 0
                for i in 1..<self.numberOfColumns {
                    let iLeft: CGFloat = self.maxScrollDirPositionForColumn[i]!
                    if iLeft < left {
                        left = iLeft; currentRow = i
                    }
                }
                let top = self.sectionInset.top + (self.lineSpacing + itemHeight) * CGFloat(currentRow)
                let itemWidth: CGFloat = self.delegate?.size(layout: self, indexPath: indexPath, itemSize: itemHeight) ?? 0
                attributes.frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
                self.cellLayoutInfo[indexPath] = attributes
                // ????????????????????????x????????????????????????cell?????????cell?????????
                left += self.interitemSpacing + itemWidth
                self.maxScrollDirPositionForColumn[currentRow] = left
                //??????section???????????????cell?????????????????????cell?????????X????????????startScrollDirPosition(??????Y??????)?????????????????????????????????Y???
                if row == (rowCount - 1) {
                    var maxLeft: CGFloat = self.maxScrollDirPositionForColumn[0]!
                    for i in 1..<self.numberOfColumns {
                        let iLeft: CGFloat = self.maxScrollDirPositionForColumn[i]!
                        if iLeft > maxLeft {
                            maxLeft = iLeft
                        }
                    }
                    // ?????????cell?????????cell???X?????????????????????????????????cell???????????????cell??????
                    self.startScrollDirPosition = maxLeft - self.interitemSpacing + self.sectionInset.right
                }
            }
            
            // Footers layout
            if self.footerSize > 0 && respondsSupplementary {
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                attributes.frame = CGRect(x: self.startScrollDirPosition, y: 0, width: self.footerSize, height: contentHeight)
                self.footLayoutInfo[indexPath] = attributes
                self.startScrollDirPosition += self.footerSize
            }
        }
    }
    
}
