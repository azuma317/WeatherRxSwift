//
//  String+percentEncoding.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation

extension String {
    
    var withPercentEncodedSpaces: String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
