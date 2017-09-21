//
//  ViewController.swift
//  EAnalytics Demo Swift
//
//  Created by François Rouault on 21/09/2017.
//  Copyright © 2017 François Rouault. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let cFlag = EAOSiteCentricCFlag()
        cFlag.setEulerianWithValues(["rolandgarros", "wimbledon"], forKey: "categorie_1")
        cFlag.setEulerianWithValues(["tennis"], forKey: "categorie_2")
        cFlag.setEulerianWithValues(["usopen"], forKey: "categorie_3")
        
        let properties = EAProperties(path: "my-path")
        properties?.setEulerianWith(cFlag)
        
        EAnalytics.track(properties)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

