//
//  SchoolListViewController.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import UIKit
import Combine

protocol SchoolListViewModelProtocol {
    var schoolsPublisher: PassthroughSubject<CollectionDifference<String>, Never> { get }
    func viewControllerDidLoadView()
    func viewControllerDidShow(itemAt index: Int)
    func viewControllerDidSelect(itemAt index: Int)
}

class SchoolListViewController<Model: SchoolListViewModelProtocol>: UIViewController, UITableViewDelegate {
    
    // TODO: Add loading indicator section
    private enum SchoolListSection: Int {
        case items = 0
    }
    
    let viewModel: Model
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.defaultReuseIdentifier)
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<SchoolListSection, String> = {
        let dataSource = UITableViewDiffableDataSource<SchoolListSection, String>(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, school) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.defaultReuseIdentifier) else { return UITableViewCell() }
            
            cell.textLabel?.text = school
            cell.textLabel?.numberOfLines = 0
            return cell
        })
        return dataSource
    }()
    
    init(viewModel: Model) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        title = "NYC High Schools"
        
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.items])
        dataSource.apply(snapshot)
        
        viewModel.schoolsPublisher.sink { [weak self] difference in
            guard let self = self else { return }
            let insertions = difference.insertions.compactMap({ change in
                if case .insert(_, let element, _ ) = change {
                    return element
                }
                return nil
            })
            
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(insertions, toSection: .items)

            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        .store(in: &cancellables)
        
        viewModel.viewControllerDidLoadView()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.viewControllerDidShow(itemAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.viewControllerDidSelect(itemAt: indexPath.row)
    }
}
