//
//  ForecastTableViewCell.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var weatherImageOutlet: UIImageView!
    
    
    func configure(weatherData: (day: String, forecasts: [ForecastModel])) {
        self.dateLabel.text = weatherData.day
        self.cityDegreesLabel.text = weatherData.forecasts[0].temp
        self.weatherMessageLabel.text = weatherData.forecasts[0].description
        
        let imageURL = URL(string: "http://api.openweathermap.org/img/w/\(weatherData.forecasts[0].imageID).png")!
        let request = URLRequest(url: imageURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 20)
        let task = URLSession.shared.dataTask(with: request) { [weak weakSelf = self](data, response, error) in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                weakSelf?.weatherImageOutlet.image = image
            }
        }
        task.resume()
    }
}
