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
    
    customizeChart(dataPoints: y, x_values: x)
  }
  
  func customizeChart(dataPoints: [Double], x_values: [Double]) {
    
    var dataEntries: [ChartDataEntry] = []
    //var label_1: [String?] = ["profit potential","loss potential","breakeven"]
    for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(x: Double(i), y: Double(x_values[i]))
      dataEntries.append(dataEntry)
    }
    
      let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "loss potential")
    let lineChartData = LineChartData(dataSet: lineChartDataSet)
    lineChartView.data = lineChartData
  }
}

