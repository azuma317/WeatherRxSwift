//
//  ViewModel.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherViewModel {
    
    private let weatherService: WeatherAPIService
    private let disposeBag = DisposeBag()
    private let formatter = DateFormatter()
    
    private let weather: Observable<Weather>
    let cityName: Observable<String>
    let weatherDescription: Observable<String>
    let temp: Observable<String>
    let weatherImageData: Observable<Data>
    let weatherBackgroundImage: Observable<WeatherBackgroundImage>
    var cellData: Observable<[(day: String, forecasts: [ForecastModel])]> {
        return weather.map(self.cells)
    }
    
    var searchText = BehaviorRelay<String>(value: "")
    
    init(weatherService: WeatherAPIService) {
        self.weatherService = weatherService
        
        weather = searchText.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ searchString -> Observable<Weather> in
                guard !searchString.isEmpty else {
                    return Observable.empty()
                }
                return weatherService.search(withCity: searchString)
            })
            .share(replay: 1)
        
        cityName = weather
            .map { $0.cityName }
        temp = weather
            .map { "\($0.currentWeather.temp)ºC" }
        weatherDescription = weather
            .map { $0.currentWeather.description }
        weatherImageData = weather
            .map { $0.currentWeather.imageID }
            .flatMap(weatherService.weatherImage)
        weatherBackgroundImage = weather
            .map { $0.currentWeather.imageID }
            .map { return WeatherBackgroundImage(imageID: $0)! }
    }
    
    private func cells(from weather: Weather) -> [(day: String, forecasts: [ForecastModel])] {
        
        func dateTimestampFromDate(date: Date) -> String {
            formatter.dateFormat = "YYMMdd HHmm"
            return formatter.string(from: date)
        }
        
        func dayTimestampFromDateTimestamp(timestamp: String) -> String {
            return String(timestamp.split(separator: " ")[0])
        }
        
        let allTimestamps = weather.forecasts
            .map { $0.date }
            .map(dateTimestampFromDate)
        
        let uniqueDayTimestamps = allTimestamps
            .map(dayTimestampFromDateTimestamp)
            .uniqueElements
        
        let forecastsForDays = uniqueDayTimestamps.map { day in
            return weather.forecasts.filter({ (forecast) -> Bool in
                let forecastTimestamp = dateTimestampFromDate(date: forecast.date)
                let dayOfForecast = dayTimestampFromDateTimestamp(timestamp: forecastTimestamp)
                
                return dayOfForecast == day
            })
        }
        
        let forecastModels = forecastsForDays.map { (forecasts) in
            return forecasts.map(forecastModel)
        }
        
        let dayStrings = weather.forecasts
            .map { $0.date.dayOfWeek(formatter: formatter) }
            .uniqueElements
        
        return Array(Zip2Sequence(_sequence1: dayStrings, _sequence2: forecastModels))
    }
    
    private func forecastModel(from forecast: Forecast) -> ForecastModel {
        return ForecastModel(
            time: forecast.date.formattedTime(formatter: formatter),
            description: forecast.description,
            temp: "\(forecast.temp)ºC",
            imageID: forecast.imageID)
    }
}
