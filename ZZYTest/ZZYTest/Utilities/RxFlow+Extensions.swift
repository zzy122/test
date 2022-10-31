//
//  RxFlow+Extensions.swift
//  GeRestarant
//
//  Created by my on 2022/6/28.
//

import Foundation
import RxFlow

extension FlowContributor {
    static func contribute(withNavigationController navigationController: BaseNavigationController, presentable: BaseViewController, withNextStepper stepper: Stepper) -> FlowContributor {
        return .contribute(withNextPresentable: navigationController.pushToViewController(presentable, animated: true), withNextStepper: stepper)
    }
}

