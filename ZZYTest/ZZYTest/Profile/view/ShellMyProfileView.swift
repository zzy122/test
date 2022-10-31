
import UIKit

private let topHeaderHeight:CGFloat = 326
private let testHeaderHeight:CGFloat = 200

enum ScrollViewType {
    var rawValue:Int {
        get {
            switch self {
            case .bottom:
                return 0
            case .top:
                return 1
            }
        }
    }
    init(rawValue:Int) {
        switch rawValue {
        case 0:
            self = .bottom
        default:
            self = .top
        }
    }
    
    case bottom
    case top
}

extension UIScrollView {
    static private let canScrollKey =  UnsafeRawPointer.init(bitPattern: "canScrollView".hashValue)
    
    static private let respondViewBlockKey =  UnsafeRawPointer.init(bitPattern: "respondViewBlockKey".hashValue)
    
    static private let scrollTypeKey =  UnsafeRawPointer.init(bitPattern: "scrollTypeKey".hashValue)
    
    var canScrollView: Bool! {
        get {
            return (objc_getAssociatedObject(self, UIScrollView.canScrollKey!) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, UIScrollView.canScrollKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var scrollType: ScrollViewType! {
        get {
            let result = objc_getAssociatedObject(self, UIScrollView.scrollTypeKey!) as? Int
            return ScrollViewType(rawValue: result ?? 0)
        }
        set {
            objc_setAssociatedObject(self, UIScrollView.scrollTypeKey!, newValue.rawValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var respondViewBlock: (() -> UIScrollView?)? {
        get {
            return objc_getAssociatedObject(self, UIScrollView.respondViewBlockKey!) as? () -> UIScrollView?
        }
        set {
            objc_setAssociatedObject(self, UIScrollView.respondViewBlockKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func bindScrollEvent(scrollType:ScrollViewType, blockView:@escaping ()->UIScrollView?) {
//        self.delegate = self
        
        self.scrollType = scrollType
        if scrollType == .bottom {
            self.canScrollView = true
        }
        
        self.respondViewBlock = blockView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch self.scrollType {
        case .bottom:
            let point = scrollView.contentOffset
            // 控制底部滑动
            let topHeight = testHeaderHeight
            if self.canScrollView {
                if point.y >= topHeight {
                    self.canScrollView = false
                    if let subScrollView = self.respondViewBlock?() {
                        subScrollView.canScrollView = true
                    }
                } else {
                    if let subScrollView = self.respondViewBlock?() {
                        subScrollView.canScrollView = false
                    }
                }
            } else {
                self.contentOffset = CGPoint(x: 0, y: topHeight)
            }
            break
        case .top:
            let point = scrollView.contentOffset
            if point.y <= 0 {
                if self.canScrollView {
                    self.canScrollView = false
                }
                if let view = self.respondViewBlock?() {
                    view.canScrollView = true
                }
            } else {
                if let view = self.respondViewBlock?() {
                    view.canScrollView = false
                }
            }
                    
            if !self.canScrollView {
                self.contentOffset = CGPoint.zero
            }
            break
        case .none: break
            
        }
    }
}


final class PageScrollView:UIScrollView,UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

final class PageTableView:UITableView,UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

final class PageCollectionView:UICollectionView,UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



class ShellMyProfileView: UIView {
    lazy var bottomScrollView:PageScrollView = {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
        return $0
    }(PageScrollView())

    lazy var topScrollView:PageScrollView = {
        $0.bounces = true
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(PageScrollView())

    lazy var commentTableView:PageTableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.tableHeaderView = UIView()
        $0.register(UINib(nibName: "ShellProfileCommentTableViewCell", bundle: .main), forCellReuseIdentifier: "ShellProfileCommentTableViewCell")

        return $0
    }(PageTableView())

    lazy var makeUpTableView:ShellProfileMakeView = ShellProfileMakeView(frame: CGRect.zero)

    private let headerView:ShellMyProfileHeader = ShellMyProfileHeader.createView()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.bottomScrollView)
        self.backgroundColor = .clear
        self.bottomScrollView.addSubview(self.headerView)
        self.bottomScrollView.addSubview(self.topScrollView)
        
        self.bottomScrollView.bindScrollEvent(scrollType: .bottom) { [weak self] in
            if let strongSelf = self {
                let currentPage = Int((self?.topScrollView.contentOffset.x ?? 0) / UIScreen.main.bounds.width)
                if currentPage == 0 {
                    return strongSelf.commentTableView
                } else {
                    return strongSelf.makeUpTableView.waterCollectionView
                }
            } else {
                return UICollectionView()
            }
            
        }
        
        self.commentTableView.bindScrollEvent(scrollType: .top) { [weak self] in
            return self?.bottomScrollView
        }
        self.makeUpTableView.waterCollectionView.bindScrollEvent(scrollType: .top) { [weak self] in
            return self?.bottomScrollView
        }

        self.topScrollView.addSubview(self.commentTableView)
        self.topScrollView.addSubview(self.makeUpTableView)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        self.headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: topHeaderHeight)
        self.bottomScrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)
        self.topScrollView.frame = CGRect(x: 0, y: topHeaderHeight, width: screenWidth, height: self.bounds.height)
        self.commentTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)

        self.makeUpTableView.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: self.bounds.height)

        self.bottomScrollView.contentSize = CGSize(width: self.bottomScrollView.frame.width, height: self.topScrollView.frame.height + topHeaderHeight)

        self.topScrollView.contentSize = CGSize(width: screenWidth * 2, height: self.bounds.height)
    }
    deinit {
        print("ddssdskk")
    }
}


extension ShellMyProfileView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShellProfileCommentTableViewCell", for: indexPath) as! ShellProfileCommentTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.scrollViewDidScroll(scrollView)
    }
}

