//
//  Weather.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation
import SwiftyJSON

class Forecast {
    
    let date: Date
    let imageID: String
    let temp: Float
    let description: String
    
    init?(json: JSON) {
        guard let timestamp = json["dt"].double,
            let imageID = json["weather"][0]["icon"].string,
            let temp = json["main"]["temp"].float,
            let description = json["weather"][0]["description"].string
            else {
                return nil
        }
        
        self.date = Date(timeIntervalSince1970: timestamp)
        self.imageID = imageID
        self.temp = temp
        self.description = description
    }
}

struct Weather {
    
    let cityName: String
    let forecasts: [Forecast]
    
    var currentWeather: Forecast {
        return forecasts[0]
    }
    
    init?(json: JSON) {
        guard let cityName = json["city"]["name"].string,
            let forecastData = json["list"].array
            else {
                return nil
        }
        
        self.cityName = cityName
        let forecasts = forecastData.compactMap(Forecast.init)
        guard !forecasts.isEmpty else {
            return nil
        }
        
        self.forecasts = forecasts
    }
}
