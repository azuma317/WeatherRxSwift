//
//  APIClient.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/18.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIClient {
    
    enum Result {
        case success(JSON)
        case failure(Error)
    }
    
    public static func apiResult(url: String = "https://httpbin.org/get", completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completion(.failure(error!))
                return
            }
            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let json = JSON(data!)
                completion(.success(json))
                return 
//                if let json = json {
//                    completion(.success(json))
//                    return
//                }
            } catch let error {
                completion(.failure(error))
            }
            }.resume()
    }
}
