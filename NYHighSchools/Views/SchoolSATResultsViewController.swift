//
//  SchoolSATResultsViewController.swift
//  NYHighSchools
//
//  Created by Maksym Gurkivskyi on 1/31/23.
//

import UIKit
import Combine

protocol SchoolSATResultsViewModelProtocol {
    var schoolNamePublisher: Published<String>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var noDataPublisher: Published<Bool>.Publisher { get }
    var numOfSatTestTakersPublisher: Published<String?>.Publisher { get }
    var satCriticalReadingAvgScorePublisher: Published<String?>.Publisher { get }
    var satMathAvgScorePublisher: Published<String?>.Publisher { get }
    var satWritingAvgScorePublisher: Published<String?>.Publisher { get }
    
    func viewControllerDidLoadView()
}

class SchoolSATResultsViewController<Model: SchoolSATResultsViewModelProtocol>: UIViewController {
    
    let viewModel: Model
    private var cancellables = Set<AnyCancellable>()

    let verticalContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }()
    
    let noDataAvailableLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 20)
        view.text = "No Data Available"
        return view
    }()
    
    let numOfSatTestTakersLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    let satCriticalReadingAvgScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    let satMathAvgScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    let satWritingAvgScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 20)
        return view
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

        view.addSubview(verticalContainer)
        
        verticalContainer.addArrangedSubview(nameLabel)
        verticalContainer.addArrangedSubview(activityView)
        verticalContainer.addArrangedSubview(noDataAvailableLabel)
        
        for label in [numOfSatTestTakersLabel, satCriticalReadingAvgScoreLabel, satMathAvgScoreLabel, satWritingAvgScoreLabel] {
            label.isHidden = true
            verticalContainer.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            verticalContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            verticalContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            verticalContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            verticalContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        view.backgroundColor = .tertiarySystemBackground
        
        viewModel.schoolNamePublisher
            .compactMap({ $0 })
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .map({ !$0 })
            .assign(to: \.isHidden, on: activityView)
            .store(in: &cancellables)
        
        viewModel.noDataPublisher
            .map({ !$0 })
            .assign(to: \.isHidden, on: noDataAvailableLabel)
            .store(in: &cancellables)
        
        viewModel.numOfSatTestTakersPublisher
            .sink { [weak self] numOfSatTestTakers in
                if let numOfSatTestTakers = numOfSatTestTakers, !numOfSatTestTakers.isEmpty {
                    self?.numOfSatTestTakersLabel.isHidden = false
                    self?.numOfSatTestTakersLabel.text = "Number of SAT test takers: \(numOfSatTestTakers)"
                }
            }
            .store(in: &cancellables)
        
        viewModel.satCriticalReadingAvgScorePublisher
            .sink { [weak self] satCriticalReadingAvgScore in
                if let satCriticalReadingAvgScore = satCriticalReadingAvgScore, !satCriticalReadingAvgScore.isEmpty {
                    self?.satCriticalReadingAvgScoreLabel.isHidden = false
                    self?.satCriticalReadingAvgScoreLabel.text = "SAT Critical Reading average score: \(satCriticalReadingAvgScore)"
                }
            }
            .store(in: &cancellables)
        
        viewModel.satMathAvgScorePublisher
            .sink { [weak self] satMathAvgScore in
                if let satMathAvgScore = satMathAvgScore, !satMathAvgScore.isEmpty {
                    self?.satMathAvgScoreLabel.isHidden = false
                    self?.satMathAvgScoreLabel.text = "SAT Math average score: \(satMathAvgScore)"
                }
            }
            .store(in: &cancellables)
        
        viewModel.satWritingAvgScorePublisher
            .sink { [weak self] satWritingAvgScore in
                if let satWritingAvgScore = satWritingAvgScore, !satWritingAvgScore.isEmpty {
                    self?.satWritingAvgScoreLabel.isHidden = false
                    self?.satWritingAvgScoreLabel.text = "SAT Writing average score: \(satWritingAvgScore)"
                }
            }
            .store(in: &cancellables)
        
        viewModel.viewControllerDidLoadView()
    }
}
