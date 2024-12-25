//
//  ChartViewController.swift
//  tracker
//
//  Created by Qamarain on 19/12/2024.
//
import UIKit
import Charts
import DGCharts

class ChartViewController: UIViewController {

    @IBOutlet var pieChartView: PieChartView!
    
    
    @IBOutlet var lblPlastic: UILabel!
    
    
    @IBOutlet var lblC2: UILabel!
    
    
    @IBOutlet var lblWater: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        updateChart() // Load initial data
        updateLabels()
    }

    private func setupChart() {
        // Your existing chart setup code...
        pieChartView.usePercentValuesEnabled = true
        pieChartView.chartDescription.enabled = false
        pieChartView.drawHoleEnabled = false // Make it a pie chart
    }

    private func updateChart() {
        var dataEntries: [PieChartDataEntry] = []
        
      /**  for (category, value) in ImpactData.shared.chartData {
              let entry = PieChartDataEntry(value: value, label: "\(category): \(value) kg") // Show category and value
              dataEntries.append(entry)
          }*/
        
        for (category, _) in ImpactData.shared.chartData {
              let entry = PieChartDataEntry(value: ImpactData.shared.chartData[category] ?? 0.0, label: category) // Use category as label only
              dataEntries.append(entry)
          }
        
        

       let dataSet = PieChartDataSet(entries: dataEntries, label: "")
    
        
        // Assign colors based on category
            dataSet.colors = dataEntries.map { entry in
                return getColor(for: entry.label ?? "")
            }

            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        
    
     //mapping the colors
         func getColor(for category: String) -> UIColor {
            switch category {
            case "Plastic Waste Reduction Product":
                return UIColor(hex: "#75AA6C")! // Green
            case "Water Conservation Product":
                return UIColor(hex: "#662565")! // Purple
            case "Carbon Emission Reduction":
                return UIColor(hex: "#F6D652")! // Yellow
            case "Others":
                return UIColor.gray // Grey for Others
            default:
                return UIColor.lightGray // Default color for any unexpected cases
            }
        }
        
        

        
        // Refresh the chart
        pieChartView.notifyDataSetChanged()
    }

    // Method to refresh the chart when called
    func refreshChart() {
        updateChart() // Call updateChart to refresh the data
        
        updateLabels() // Update the labels with the latest data
    }

    private func updateLabels() {
        lblPlastic.text = "\(ImpactData.shared.chartData["Plastic Waste Reduction Product"] ?? 0.0) kg"
        lblC2.text = "\(ImpactData.shared.chartData["Carbon Emission Reduction"] ?? 0.0) kg"
        lblWater.text = "\(ImpactData.shared.chartData["Water Conservation Product"] ?? 0.0) L"
    }
}



//custom color
extension UIColor {
    convenience init?(hex: String) {
        var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexColor = hexColor.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
