//
//  ViewController.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ForecastModel {
    let time: String
    let description: String
    let temp: String
    let imageID: String
}

class WeatherOverviewViewController: UIViewController {
    
    private var viewModel: WeatherViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var forecastsTableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherBackgroundImageView: UIImageView!
    @IBOutlet weak var weatherView: UIView!
    
    private func addBindsToViewModel(viewModel: WeatherViewModel) {
        
        cityTextField.rx.text
            .map{ String($0 ?? "") }
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        viewModel.cityName
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.temp
            .bind(to: cityDegreesLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherDescription
            .bind(to: weatherMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherImageData
            .map(UIImage.init)
            .bind(to: weatherIconImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.weatherBackgroundImage
            .map { $0.image }
            .bind(to: weatherBackgroundImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.cellData
            .bind(to: forecastsTableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastTableViewCell
                cell.configure(weatherData: element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastsTableView.delegate = self
        
        viewModel = WeatherViewModel(weatherService: WeatherAPIService())
        addBindsToViewModel(viewModel: viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        forecastsTableView.tableHeaderView?.bounds.size.height = view.bounds.height
        forecastsTableView.tableHeaderView = forecastsTableView.tableHeaderView
    }
    
    private var tableViewData: [(data: String, forecasts: [ForecastModel])]? {
        didSet {
            forecastsTableView.reloadData()
        }
    }
}

extension WeatherOverviewViewController: UITableViewDataSource, RxTableViewDataSourceType {
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[(data: String, forecasts: [ForecastModel])]>) {
        switch observedEvent {
        case .next(let items):
            tableViewData = items
        case .error(let error):
            print(error)
            presentError()
        case .completed:
            tableViewData = nil
        }
    }
    
    typealias Element = [(data: String, forecasts: [ForecastModel])]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?[section].forecasts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        
        guard let forecast = tableViewData?[indexPath.section].forecasts[indexPath.item] else {
            return cell
        }
        
        cell.cityDegreesLabel.text = forecast.temp
        cell.dateLabel.text = forecast.time
        cell.weatherMessageLabel.text = forecast.description
        return cell
    }
    
}

extension WeatherOverviewViewController: UITableViewDelegate {}

