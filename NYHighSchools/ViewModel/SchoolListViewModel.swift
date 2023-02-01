//
//  SchoolListViewModel.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import Foundation
import Combine

protocol SchoolListViewModelDataSourceProtocol {
    func loadSchools(offset: UInt, limit: UInt, completion: @escaping ([SchoolModel])->())
}

class SchoolListViewModel<DataSource: SchoolListViewModelDataSourceProtocol>: SchoolListViewModelProtocol {
    let dataSource: DataSource

    @Published var schools: [SchoolModel] = []
    var schoolsPublisher = PassthroughSubject<CollectionDifference<SchoolModel>, Never>()
    
    private var isLoading = false
    private let itemsPerPage = 10
    private var allLoaded = false
    
    func loadMoreSchools() {
        guard !isLoading && !allLoaded else { return }
        
        isLoading = true
        dataSource.loadSchools(offset: UInt(schools.count), limit: 50) { [weak self] schools in
            guard let self = self else { return }
            let oldSchoold = self.schools
            self.schools.append(contentsOf: schools)
            self.isLoading = false
            self.allLoaded = schools.count == 0
            
            self.schoolsPublisher.send(self.schools.difference(from: oldSchoold))
        }
    }
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
}
