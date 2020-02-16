//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Patrycja on 11/1/19.
//  Copyright © 2019 agh. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
}
