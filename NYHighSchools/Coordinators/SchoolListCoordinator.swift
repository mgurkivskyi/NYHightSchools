//
//  SchoolListCoordinator.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import UIKit

class SchoolListCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var childrenCoordinator: (any Coordinator)?
    var viewController: SchoolListViewController<SchoolListViewModel<API>>

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let viewModel = SchoolListViewModel(dataSource: API())
        viewController = SchoolListViewController(viewModel: viewModel)
        
        viewModel.navigationDelegate = self
    }

    func start() {
        navigationController.viewControllers = [viewController]
    }
}

extension SchoolListCoordinator: SchoolListViewModelNavigationDelegate {
    
    func schoolList(didSelect school: SchoolModel) {
        let coordinator = SchoolSATResultsCoordinator(navigationController: navigationController, school: school)
        coordinator.parentCoordinator = coordinator
        childrenCoordinator = coordinator
        coordinator.start()
    }
}
