
import UIKit

class ShellProfileMakeView: UIView {
    
    lazy var sizes:[CGSize] = {
        var i = 0
        var result:[CGSize] = []
        while (i < 20) {
            let width:CGFloat = max(50, CGFloat(arc4random()).truncatingRemainder(dividingBy: 200))
            
            let height:CGFloat = max(100, CGFloat(arc4random()).truncatingRemainder(dividingBy: 200))
            result.append(CGSize(width: width, height: height))
            i += 1
        }
        return result
    }()
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    private lazy var waterLayout: GXWaterfallViewLayout = {
        let layout = GXWaterfallViewLayout()
        layout.lineSpacing = 10.0
        layout.interitemSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = self.scrollDirection
//        layout.headerSize = 40.0
//        layout.footerSize = 40.0
        layout.numberOfColumns = 2
        layout.delegate = self
        
        return layout
    }()
    
    lazy var waterCollectionView: PageCollectionView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let collectionView = PageCollectionView(frame: frame, collectionViewLayout: self.waterLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib(nibName: "ShellProfileMakeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ShellProfileMakeCollectionViewCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.waterCollectionView.backgroundColor = .clear
        self.addSubview(self.waterCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.waterCollectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
}

extension ShellProfileMakeView:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShellProfileMakeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShellProfileMakeCollectionViewCell", for: indexPath) as! ShellProfileMakeCollectionViewCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.scrollViewDidScroll(scrollView)
    }
}
extension ShellProfileMakeView:GXWaterfallViewLayoutDelegate {
    func imageAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        
        return sizes[indexPath.row]
    }
    
    func size(layout: GXWaterfallViewLayout, indexPath: IndexPath, itemSize: CGFloat) -> CGFloat {
        if layout.scrollDirection == .vertical {
            return self.imageAtIndexPath(indexPath).height / self.imageAtIndexPath(indexPath).width * itemSize
        }
        else {
            return self.imageAtIndexPath(indexPath).height / self.imageAtIndexPath(indexPath).width * itemSize
        }
    }
}
