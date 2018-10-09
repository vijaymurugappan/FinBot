//
//  ChartCell.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 8/29/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Firebase
import Charts

class LineChartCell: UITableViewCell, ChartViewDelegate {
    
    let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient\
    let gradCol2 = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
    
    
    func updateGraph(user: User?) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let lineChartView = LineChartView(frame: frame)
        lineChartView.delegate = self
        self.contentView.addSubview(lineChartView)
        var lineChartEntry  = [ChartDataEntry]()
        let numbers : [Double] = [user!.januaryE as! Double,user!.febrauryE as! Double,user!.marchE as! Double,user!.aprilE as! Double,user!.mayE as! Double,user!.juneE as! Double,user!.julyE as! Double,user!.augustE as! Double,user!.septemberE as! Double,user!.octoberE as! Double,user!.novemberE as! Double,user!.decemberE as! Double]
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "SPENDING CURVE")
        
        line1.colors = [NSUIColor.blue]
        line1.drawFilledEnabled = true
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: self.gradientColors, locations: colorLocations) // Gradient Object
        line1.fill = Fill.fillWithRadialGradient(gradient!)
        let data = LineChartData()
        
        data.addDataSet(line1)
        
        lineChartView.data = data
        lineChartView.chartDescription?.text = "EXPENDITURE"
        lineChartView.animate(xAxisDuration: 2, easingOption: .easeInBounce)
        lineChartView.notifyDataSetChanged()
    }
    
    func updatePieChart(user: User?) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let pieChartView = PieChartView(frame: frame)
        pieChartView.delegate = self
        let q1: Double = (user!.januaryE?.doubleValue)! + (user!.febrauryE?.doubleValue)! + (user!.marchE?.doubleValue)!
        let q2: Double = (user!.aprilE?.doubleValue)! + (user!.mayE?.doubleValue)! + (user!.juneE?.doubleValue)!
        let q3: Double = (user!.julyE?.doubleValue)! + (user!.augustE?.doubleValue)! + (user!.septemberE?.doubleValue)!
        let q4: Double = (user!.octoberE?.doubleValue)! + (user!.novemberE?.doubleValue)! + (user!.decemberE?.doubleValue)!
        self.contentView.addSubview(pieChartView)
        var values = [PieChartDataEntry]()
        let numbers : [Double] = [q1,q2,q3,q4]
        for i in 0..<numbers.count {
            let value = PieChartDataEntry(value: numbers[i], label: "Quarter \(i+1)")
            values.append(value)
        }
        let ds = PieChartDataSet(values: values, label: nil)
        let data = PieChartData(dataSets: [ds])
        let colors = [UIColor.red, UIColor.blue, UIColor.brown, UIColor.magenta]
        ds.colors = colors 
        pieChartView.data = data
        pieChartView.chartDescription?.text = "EXPENDITURE"
        pieChartView.animate(yAxisDuration: 2, easingOption: .easeInCirc)
        pieChartView.notifyDataSetChanged()
    }
    
    func updateBarChart(user: User?) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let barChartView = BarChartView(frame: frame)
        barChartView.delegate = self
        self.contentView.addSubview(barChartView)
        var values = [BarChartDataEntry]()
        let numbers : [Double] = [user!.januaryE as! Double,user!.febrauryE as! Double,user!.marchE as! Double,user!.aprilE as! Double,user!.mayE as! Double,user!.juneE as! Double,user!.julyE as! Double,user!.augustE as! Double,user!.septemberE as! Double,user!.octoberE as! Double,user!.novemberE as! Double,user!.decemberE as! Double]
        for i in 0..<numbers.count {
            let value = BarChartDataEntry(x: Double(i), y: numbers[i])
            values.append(value)
        }
        let ds = BarChartDataSet(values: values, label: "SPENDING CURVE")
        let data = BarChartData(dataSets: [ds])
        
        barChartView.data = data
        barChartView.chartDescription?.text = "EXPENDITURE"
        barChartView.animate(yAxisDuration: 2)
        barChartView.notifyDataSetChanged()
    }
    
    func updateHorizBarChart(user: User?) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let horizBarChart = HorizontalBarChartView(frame: frame)
        //let lineChartView = LineChartView()
        horizBarChart.delegate = self
        self.contentView.addSubview(horizBarChart)
        var values = [BarChartDataEntry]()
        let numbers : [Double] = [user!.januaryE as! Double,user!.febrauryE as! Double,user!.marchE as! Double,user!.aprilE as! Double,user!.mayE as! Double,user!.juneE as! Double,user!.julyE as! Double,user!.augustE as! Double,user!.septemberE as! Double,user!.octoberE as! Double,user!.novemberE as! Double,user!.decemberE as! Double]
        for i in 0..<numbers.count {
            let value = BarChartDataEntry(x: Double(i), y: numbers[i])
            values.append(value)
        }
        let ds = BarChartDataSet(values: values, label: "SPENDING CURVE")
        let data = BarChartData(dataSets: [ds])
        horizBarChart.data = data
        horizBarChart.chartDescription?.text = "EXPENDITURE"
        horizBarChart.animate(yAxisDuration: 2)
        horizBarChart.notifyDataSetChanged()
    }
    
    func updateTwoLineChart(user: User?) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let line2ChartView = LineChartView(frame: frame)
        line2ChartView.delegate = self
        self.contentView.addSubview(line2ChartView)
        var lineChartEntry  = [ChartDataEntry]()
        var line2CE = [ChartDataEntry]()
        let numbers : [Double] = [user!.januaryE as! Double,user!.febrauryE as! Double,user!.marchE as! Double,user!.aprilE as! Double,user!.mayE as! Double,user!.juneE as! Double,user!.julyE as! Double,user!.augustE as! Double,user!.septemberE as! Double,user!.octoberE as! Double,user!.novemberE as! Double,user!.decemberE as! Double]
        let num2 : [Double] = [user!.januaryS as! Double,user!.febrauryS as! Double,user!.marchS as! Double,user!.aprilS as! Double,user!.mayS as! Double,user!.juneS as! Double,user!.julyS as! Double,user!.augustS as! Double,user!.septemberS as! Double,user!.octoberS as! Double,user!.novemberS as! Double,user!.decemberS as! Double]
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        for j in 0..<num2.count {
            let v2 = ChartDataEntry(x: Double(j), y: num2[j])
            line2CE.append(v2)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "SPENDING CURVE")
        let line2 = LineChartDataSet(values: line2CE, label: "EARNING CURVE")
        
        line1.colors = [NSUIColor.blue]
        line2.colors = [NSUIColor.red]
        line1.drawFilledEnabled = true
        line2.drawFilledEnabled = true
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: self.gradientColors, locations: colorLocations) // Gradient Object
        let grad2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradCol2, locations: colorLocations)
        line1.fill = Fill.fillWithRadialGradient(gradient!)
        line2.fill = Fill.fillWithRadialGradient(grad2!)
        
        let data = LineChartData(dataSets: [line1,line2])
        
        line2ChartView.data = data
        line2ChartView.chartDescription?.text = "EXPENDITURE"
        line2ChartView.animate(xAxisDuration: 2, easingOption: .easeInBounce)
        line2ChartView.notifyDataSetChanged()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
}
