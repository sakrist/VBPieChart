//
//  ViewController.swift
//  VBPieChart_swift
//
//  Created by Volodymyr Boichentsov on 10/02/2015.
//  Copyright (c) 2015 Volodymyr Boichentsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let chart = VBPieChart();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(chart);
        
        chart.frame = CGRect(x: 10, y: 50, width: 300, height: 300);
        chart.holeRadiusPrecent = 0.3;

        
        let chartValues = [ ["name":"first", "value": 50, "color":UIColor(hexString:"dd191daa")],
        ["name":"second", "value": 20, "color":UIColor(hexString:"d81b60aa")],
        ["name":"third", "value": 40, "color":UIColor(hexString:"8e24aaaa")],
        ["name":"fourth 2", "value": 70, "color":UIColor(hexString:"3f51b5aa")],
        ["name":"fourth 3", "value": 65, "color":UIColor(hexString:"5677fcaa")],
        ["name":"fourth 4", "value": 23, "color":UIColor(hexString:"2baf2baa")],
        ["name":"fourth 5", "value": 34, "color":UIColor(hexString:"b0bec5aa")],
        ["name":"fourth 6", "value": 54, "color":UIColor(hexString:"f57c00aa")]
        ];
        
        chart.setChartValues(chartValues as [AnyObject], animation:true);
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

