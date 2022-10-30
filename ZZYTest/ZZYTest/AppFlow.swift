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
    
    private let _root: UINavigationController = UINavigationController()
    
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
        let viewController = ViewControllers()
        viewController.viewModel = viewModel
        _root.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToMakeUp() -> FlowContributors {
        let viewModel = MakeUpViewModel()
        let viewController = MakeUpViewController()
        viewController.viewModel = viewModel
        _root.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToChatList() -> FlowContributors {
//        let viewModel = MakeUpViewModel()
        let viewController = ShellMyProfileViewController()
        _root.pushViewController(viewController, animated: true)
        return FlowContributors.none
    }
    
}
