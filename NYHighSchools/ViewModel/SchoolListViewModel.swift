//
//  SchoolListViewModel.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import Foundation
import Combine

protocol SchoolListViewModelDataProviderProtocol {
    func loadSchools(offset: UInt, limit: UInt, completion: @escaping ([SchoolModel])->())
}

protocol SchoolListViewModelNavigationDelegate: AnyObject {
    func schoolList(didSelect school: SchoolModel)
}

class SchoolListViewModel<DataSource: SchoolListViewModelDataProviderProtocol>: SchoolListViewModelProtocol {
    
    let dataSource: DataSource
    weak var navigationDelegate: SchoolListViewModelNavigationDelegate?
    
    private var schoolsModels: [SchoolModel] = []
    private var schools: [String] = []
    var schoolsPublisher = PassthroughSubject<CollectionDifference<String>, Never>()

    private var isLoading = false
    private let itemsPerPage: UInt = 50
    private var allLoaded = false
    
    private func loadMoreSchools() {
        guard !isLoading && !allLoaded else { return }
        
        isLoading = true
        dataSource.loadSchools(offset: UInt(schools.count), limit: itemsPerPage) { [weak self] schools in
            guard let self = self else { return }
            self.isLoading = false
            self.allLoaded = schools.count == 0

            let oldSchoolNames = self.schools
            
            self.schoolsModels.append(contentsOf: schools)
            self.schools.append(contentsOf: schools.map({ $0.school_name }))
            
            self.schoolsPublisher.send(self.schools.difference(from: oldSchoolNames))
        }
    }
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func viewControllerDidLoadView() {
        loadMoreSchools()
    }
    
    func viewControllerDidShow(itemAt index: Int) {
        if index > schools.count - 5 {
            loadMoreSchools()
        }
    }
    
    func viewControllerDidSelect(itemAt index: Int) {
        let school = schoolsModels[index]
        navigationDelegate?.schoolList(didSelect: school)
    }
}
