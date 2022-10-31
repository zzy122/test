//
//  BaseViewController.swift
//  XGXW2021
//
//  Created by my on 2021/1/14.
//

import UIKit

internal class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isEnableInteractivePopGesture: Bool = true {
        didSet {
            if isViewLoaded {
                navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnableInteractivePopGesture
            }
        }
    }
    
    var isBackBarButtonItemEnable: Bool = true {
        didSet {
            if isViewLoaded {
                if isBackBarButtonItemEnable {
                    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_navi_back"),
                                                                       style: .plain,
                                                                       target: self,
                                                                       action: #selector(customPopViewController))
                } else {
                    navigationItem.leftBarButtonItem = nil
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .bottom
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnableInteractivePopGesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.isTranslucent = false
        
        if isBackBarButtonItemEnable {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_navi_back"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(customPopViewController))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func customPopViewController() {
        navigationController?.popViewController(animated: true)
    }
}
