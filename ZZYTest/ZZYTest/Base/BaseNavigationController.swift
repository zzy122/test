//
//  BaseNavigationController.swift
//  XGXW2021
//
//  Created by my on 2021/1/15.
//

import UIKit
import GeSwift
import WrapNavgiationController

internal class BaseNavigationController: UINavigationController {
    
    @discardableResult
    func pushRootViewController(_ viewController: UIViewController, animated: Bool) -> UIViewController {
        if viewController is WrapViewController {
            super.pushViewController(viewController, animated: true)
            return  viewController
        } else {
            let wrapController = WrapViewController(viewController)
            super.pushViewController(wrapController, animated: true)
            return wrapController
        }
    }
        
    @discardableResult
    func pushToViewController(_ viewController: UIViewController, animated: Bool) -> UIViewController {
        if viewController is WrapViewController {
            viewController.hidesBottomBarWhenPushed = true
            super.pushViewController(viewController, animated: true)
            return viewController
        } else {
            let wrapController = WrapViewController(viewController)
            wrapController.hidesBottomBarWhenPushed = true
            super.pushViewController(wrapController, animated: true)
            return wrapController
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
