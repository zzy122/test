//
//  AppFlow.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import RxFlow

internal final class AppFlow: Flow {
    var root: Presentable { _root }
    
    private let _root = BaseNavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .viewControllers:
            return navigateToViewControllers()
        case .makeUp:
            return navigateToMakeUp()
        case .chatList:
            return navigateToChatList()
        }
    }
    
    private func navigateToViewControllers() -> FlowContributors {
        let viewModel = ViewControllersViewModel()
        let viewController = ViewControllers.instantiate(withViewModel: viewModel)
        return .one(flowContributor: .contribute(withNavigationController: _root, presentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToMakeUp() -> FlowContributors {
        let viewModel = MakeUpViewModel()
        let viewController = MakeUpViewController.instantiate(withViewModel: viewModel)
        return .one(flowContributor: .contribute(withNavigationController: _root, presentable: viewController, withNextStepper: viewModel))
    }
    private func navigateToChatList() -> FlowContributors {
        let viewController = ShellMyProfileViewController()
        _root.pushToViewController(viewController, animated: true)
        return FlowContributors.none
    }
}
