//
//  NewsController.swift
//  stocks
//
//  Created by zipeng lin on 4/24/22.
//  Copyright © 2022 dk. All rights reserved.
//


import UIKit
import Charts

class LineChartViewController: UIViewController {
  
    var y: [Double] = []
    var x: [Double] = []
  @IBOutlet weak var lineChartView: LineChartView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customizeChart(dataPoints: x, y_values: y)
  }
  func customizeChart(dataPoints: [Double], y_values: [Double]) {
    print(y_values)
    print(dataPoints)
    var dataEntries: [ChartDataEntry] = []
    var x = 0
    for i in dataPoints {
        
        let dataEntry = ChartDataEntry(x: Double(i), y: Double(y_values[x]))
        x = x+1
      dataEntries.append(dataEntry)
    }
    
      let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "profit predict")
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
    lineChartView.data = lineChartData
  }
}

