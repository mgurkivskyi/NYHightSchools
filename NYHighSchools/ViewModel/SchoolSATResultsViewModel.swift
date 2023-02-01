//
//  SchoolSATResultsViewModel.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import Foundation
import Combine

protocol SchoolSATResultsViewModelDataSourceProtocol {
    func loadSAT(for school: SchoolModel, completion: @escaping (SchoolSATModel?)->())
}

class SchoolSATResultsViewModel<DataSource: SchoolSATResultsViewModelDataSourceProtocol> {
    let dataSource: DataSource
    var school: SchoolModel

    @Published var schoolName: String
    @Published var isLoading: Bool = true
    @Published var noData: Bool = false
    @Published var numOfSatTestTakers: String?
    @Published var satCriticalReadingAvgScore: String?
    @Published var satMathAvgScore: String?
    @Published var satWritingAvgScore: String?
    
    init(dataSource: DataSource, school: SchoolModel) {
        self.dataSource = dataSource
        self.school = school
        self.schoolName = school.school_name
    }
    
    func loadSAT() {
        isLoading = true
        dataSource.loadSAT(for: school) { [weak self] results in
            guard let self = self else { return }
            self.isLoading = false
            if let results = results {
                self.numOfSatTestTakers = results.num_of_sat_test_takers
                self.satCriticalReadingAvgScore = results.sat_critical_reading_avg_score
                self.satMathAvgScore = results.sat_math_avg_score
                self.satWritingAvgScore = results.sat_writing_avg_score
            } else {
                self.noData = true
            }
        }
    }
}

extension SchoolSATResultsViewModel: SchoolSATResultsViewModelProtocol {
    
    var schoolNamePublisher: Published<String>.Publisher { $schoolName }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var numOfSatTestTakersPublisher: Published<String?>.Publisher { $numOfSatTestTakers }
    var satCriticalReadingAvgScorePublisher: Published<String?>.Publisher { $satCriticalReadingAvgScore }
    var satMathAvgScorePublisher: Published<String?>.Publisher { $satMathAvgScore }
    var satWritingAvgScorePublisher: Published<String?>.Publisher { $satWritingAvgScore }
    var noDataPublisher: Published<Bool>.Publisher { $noData }

    func viewControllerDidLoadView() {
        loadSAT()
    }
}
