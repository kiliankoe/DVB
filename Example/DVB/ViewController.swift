//
//  ViewController.swift
//  DVB
//
//  Created by Kilian Koeltzsch on 05/06/2016.
//  Copyright (c) 2016 Kilian Koeltzsch. All rights reserved.
//

import UIKit
import DVB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DVB.monitor("Pirnaischer Platz", limit: 5, line: "3") { (connections) in
            for con in connections {
                print(con)
            }
        }
    }
}
