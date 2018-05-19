//
//  WeatherBackgroundImage.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import UIKit

enum WeatherBackgroundImage: String {
    
    case Cloudy = "cloudy"
    case Sunny = "sunny"
    
    init?(imageID: String) {
        switch imageID {
        case "01d", "02d", "03d", "01n", "02n", "03n":
            self = .Sunny
        case "04d", "09d", "10d", "11d", "13d", "50d", "04n", "09n", "10n", "11n", "13n", "50n":
            self = .Cloudy
        default:
            return nil
        }
    }
    
    var image: UIImage {
        print(rawValue)
        return UIImage(named: rawValue)!
    }
}
