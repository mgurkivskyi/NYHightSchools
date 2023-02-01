//
//  Coordinator.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import UIKit

protocol Coordinator {
    associatedtype ViewController: UIViewController
    var parentCoordinator: (any Coordinator)? { get }
    var childrenCoordinator: (any Coordinator)? { get }
    var viewController: ViewController { get }
}
