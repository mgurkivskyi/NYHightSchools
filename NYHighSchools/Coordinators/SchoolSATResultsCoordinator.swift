//
//  SchoolSATResultsCoordinator.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import UIKit

class SchoolSATResultsCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var childrenCoordinator: (any Coordinator)?
    var viewController: SchoolSATResultsViewController<SchoolSATResultsViewModel<API>>

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController, school: SchoolModel) {
        self.navigationController = navigationController

        let viewModel = SchoolSATResultsViewModel(dataSource: API(), school: school)
        viewController = SchoolSATResultsViewController(viewModel: viewModel)
    }

    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
}
