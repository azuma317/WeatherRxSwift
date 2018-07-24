//
//  WeatherAPIService.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class WeatherAPIService {
    
    private struct Constants {
        static let APPID = "a1145ac628546ea64946ab79ae986fde"
        static let baseURL = "http://api.openweathermap.org/"
    }
    
    enum ResourcePath: String {
        case Forecast = "data/2.5/forecast"
        case Icon = "img/w/"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum APIError: Error {
        case CannotParse
    }
    
    func search(withCity city: String) -> Observable<Weather> {
        
        let encodedCity = city.withPercentEncodedSpaces
        
        let params: [String:String] = [
            "q": encodedCity,
            "units": "metric",
            "type": "like",
            "APPID": Constants.APPID
        ]
        
        return request(.get, ResourcePath.Forecast.path, parameters: params, encoding: URLEncoding.default)
            .json()
            .map(JSON.init)
            .flatMap { json -> Observable<Weather> in
                guard let weather: Weather = Weather(json: json) else {
                    return Observable.empty()
                }
                return Observable.just(weather)
        }
    }
    
    func weatherImage(forID imageID: String) -> Observable<Data> {
        return request(.get, ResourcePath.Icon.path + imageID + ".png").data()
    }
}
