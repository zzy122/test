//
//  BaseViewController+RxFlow.swift
//  XGXW2021
//
//  Created by my on 2021/1/15.
//

import UIKit
import RxFlow
import RxSwift
import GeSwift

protocol ViewModel: Stepper {}

protocol ServicesViewModel: ViewModel {
    associatedtype Services
    var services: Services! { get set }
}

protocol ViewModelBased: AnyObject {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}

extension BaseViewController {
    static func instantiate() -> Self {
        return Self()
    }
}

extension ViewModelBased where Self: BaseViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: BaseViewController, ViewModelType: ServicesViewModel {
    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices services: ServicesType) -> Self
        where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Services {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        viewController.viewModel.services = services
        return viewController
    }
}

extension Reactive where Base: BaseViewController {
    var willAppear: Observable<Void> {
        return methodInvoked(#selector(base.viewWillAppear(_:))).map({ _ in () })
    }
    
    var didAppear: Observable<Void> {
        return methodInvoked(#selector(base.viewDidDisappear(_:))).map({ _ in () })
    }
    
    var willDisappear: Observable<Void> {
        return methodInvoked(#selector(base.viewWillDisappear(_:))).map({ _ in () })
    }
    
    var didDisappear: Observable<Void> {
        return methodInvoked(#selector(base.viewDidDisappear(_:))).map({ _ in () })
    }
}
