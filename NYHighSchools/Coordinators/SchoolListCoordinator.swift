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
    var viewController: SchoolListViewController<SchoolListViewModel<SchoolListDataSource>>

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let viewModel = SchoolListViewModel(dataSource: SchoolListDataSource())
        viewController = SchoolListViewController(viewModel: viewModel)
    }

    func start() {
        navigationController.viewControllers = [viewController]
    }
}
