//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Spencer Forrest on 05/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    func configureCell(forecast: Forecast){
        dayLabel.text = forecast.date
        weatherTypeLabel.text = forecast.weatherType
        maxTempLabel.text = "\(forecast.highTemp)°C"
        minTempLabel.text = "\(forecast.lowTemp)°C"
        weatherIcon.image = UIImage(named: forecast.weatherType)
    }
}
