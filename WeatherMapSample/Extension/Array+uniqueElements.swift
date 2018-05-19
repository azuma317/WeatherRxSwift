//
//  Array+uniqueElements.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var uniqueElements: Array<Element> {
        var seen: [Element:Bool] = [:]
        return self.compactMap { element in
            guard seen[element] == nil else {
                return nil
            }
            
            seen[element] = true
            return element
        }
    }
}
