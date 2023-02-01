//
//  SchoolSATModel.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 2/1/23.
//

import Foundation

struct SchoolSATModel: Decodable {
    let num_of_sat_test_takers: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}
