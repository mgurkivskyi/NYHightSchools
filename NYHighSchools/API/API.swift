//
//  API.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import Foundation

// TODO: Add error handling
class API {}

extension API: SchoolListViewModelDataSourceProtocol {
    
    func loadSchools(offset: UInt, limit: UInt, completion: @escaping ([SchoolModel])->()) {
        guard var components = URLComponents(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") else { return }
        components.queryItems = [
            URLQueryItem(name: "$limit", value: "\(limit)"),
            URLQueryItem(name: "$offset", value: "\(offset)"),
            URLQueryItem(name: "$order", value: "school_name")
        ]
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, let object = try? JSONDecoder().decode([SchoolModel].self, from: data) {
                DispatchQueue.main.async {
                    completion(object)
                }
            } else if let error = error {
                print("HTTP Request Failed: \(error)")
            } else {
                print("Invalid Response")
            }
        }.resume()
    }
}

extension API: SchoolSATResultsViewModelDataSourceProtocol {
    
    func loadSAT(for school: SchoolModel, completion: @escaping (SchoolSATModel?)->()) {
        guard var components = URLComponents(string: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json") else { return }
        components.queryItems = [
            URLQueryItem(name: "dbn", value: school.dbn)
        ]
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, let object = try? JSONDecoder().decode([SchoolSATModel].self, from: data) {
                DispatchQueue.main.async {
                    completion(object.first)
                }
            } else if let error = error {
                print("HTTP Request Failed: \(error)")
            } else {
                print("Invalid Response")
                if let data = data, let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
            }
        }.resume()
    }
}
