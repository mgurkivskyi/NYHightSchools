//
//  SchoolModel.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import Foundation

struct SchoolModel: Decodable, Equatable, Hashable {
    let dbn: String
    let school_name: String
}
