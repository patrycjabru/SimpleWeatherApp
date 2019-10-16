//
//  ViewController.swift
//  WeatherApp
//
//  Created by Student on 16.10.2019.
//  Copyright © 2019 agh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBAction func onNext(_ sender: Any) {
        print("Next!")
    }
    
    @IBAction func onPrev(_ sender: Any) {
        print("Prev!")
    }

}

