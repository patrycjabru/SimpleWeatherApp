//
//  CityRecord.swift
//  WeatherApp
//
//  Created by Patrycja on 11/1/19.
//  Copyright © 2019 agh. All rights reserved.
//

import UIKit

class CityRecord {
    var name: String
    var temperature: String
    var weatherIcon: UIImage
    var id: String
    
    init(name: String, temperature: String, weatherIcon: UIImage, id: String) {
        self.name = name
        self.temperature = temperature
        self.weatherIcon = weatherIcon
        self.id = id
    }
}
