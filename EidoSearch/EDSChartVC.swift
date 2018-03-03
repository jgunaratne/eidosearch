//
//  ChartVC.swift
//  EidoSearch
//
//  Created by Junius Gunaratne on 1/29/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import MaterialComponents

public class EDSChartVC: UIViewController, ChartViewDelegate {

  public let appBar = MDCAppBar()
  
  var dates = NSMutableArray()
  let infoLabel = UILabel()
  var lineView: LineChartView!
  let nameLabel = UILabel()
  let priceLabel = UILabel()
  let priceDescLabel = UILabel()
  var timeButton = UIBarButtonItem()
  
  private var _prediction = NSDictionary()
  @objc public var prediction: NSDictionary {
    get {
      return _prediction
    }
    set(newValue) {
      _prediction = newValue
    }
  }
  
  private var _result = NSDictionary()
  @objc public var result: NSDictionary {
    get {
      return _result
    }
    set(newValue) {
      _result = newValue
    }
  }
  
  private var _projectionType = EDSProjection.projection5D
  @objc public var projectionType: EDSProjection {
    get {
      return _projectionType
    }
    set(newValue) {
      _projectionType = newValue
      var timeIcon = UIImage(named: "ic_looks_5_white")
      switch (projectionType) {
      case .projection1D:
        timeIcon = UIImage(named: "ic_looks_1_white")
        break
      case .projection5D:
        timeIcon = UIImage(named: "ic_looks_5_white")
        break
      case .projection1M:
        timeIcon = UIImage(named: "ic_filter_1_white")
        break
      case .projection3M:
        timeIcon = UIImage(named: "ic_filter_3_white")
        break
      case .projection6M:
        timeIcon = UIImage(named: "ic_filter_6_white")
        break
      case .projection1Y:
        timeIcon = UIImage(named: "ic_filter_1_white")
        break
      default:
        break
      }
      timeButton.image = timeIcon
    }
  }

  let bgColor = UIColor(
    red: CGFloat(21) / CGFloat(255),
    green: CGFloat(26) / CGFloat(255),
    blue: CGFloat(31) / CGFloat(255),
    alpha: 1)
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    self.addChildViewController(appBar.headerViewController)
    
    appBar.headerViewController.headerView.backgroundColor = UIColor.clear
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes =
      [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    appBar.navigationBar.titleAlignment = .leading

    let timeIcon = UIImage(named: "ic_looks_5_white")
    timeButton = UIBarButtonItem(image: timeIcon,
                                 style: .done,
                                 target: self,
                                 action: #selector(didSelectTime))
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func didSelectTime() {
    
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    let contentView = UIView(frame: view.frame)
    contentView.backgroundColor = bgColor
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(contentView)

    title = result["name"] as? String

    let lineChartFrame = CGRect(x: -10,
                                y: -10,
                                width: view.frame.size.width + 20,
                                height: view.frame.size.height + 20)
    lineView = LineChartView(frame: lineChartFrame)
    lineView.delegate = self
    lineView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.addSubview(lineView)
    
    infoLabel.text = "Projected price shown in yellow. Upper line is projected high. Lower line is projected low. Middle line is projected average."
    infoLabel.textColor = UIColor.white
    infoLabel.font = UIFont.systemFont(ofSize: 10)
    infoLabel.numberOfLines = 2
    infoLabel.frame = CGRect(x: 30,
                             y: contentView.frame.size.height - 150,
                             width: contentView.frame.size.width - 60,
                             height: 100)
    contentView.addSubview(infoLabel)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let patterns = prediction["patterns"] as! NSArray
    let firstPattern = patterns[0] as! NSDictionary
    let queryResults = firstPattern["queryResults"] as! NSArray
    let firstResults = queryResults[0] as! NSDictionary
    let dataSeries = firstResults["dataSeries"] as! NSArray
    var chartDataEntryArray = Array<ChartDataEntry>()
    for i in 0..<dataSeries.count {
      let dataXY = dataSeries[i] as! [String:Any]
      let dataX = dataXY["x"] as! String
      let dataY = dataXY["y"] as! String
      let date = dateFormatter.date(from: dataX)
      let timeInterval = date?.timeIntervalSince1970
      let dataEntry = ChartDataEntry.init(x: Double(timeInterval!),
                                          y: Double(dataY)!, data: date as AnyObject?)
      chartDataEntryArray.append(dataEntry)
    }
    
    let statistics = prediction["statistics"] as! NSArray
    let firstStats = statistics[0] as! NSDictionary
    let projectionData = firstStats["projectionData"] as! NSDictionary
    let projectionTimeSeries = projectionData["projectionTimeSeries"] as! NSArray
    var chartDataEntryArray2 = Array<ChartDataEntry>()
    var lowerEntryArray = Array<ChartDataEntry>()
    var upperEntryArray = Array<ChartDataEntry>()
    for i in 0..<projectionTimeSeries.count {
      let dataXY = projectionTimeSeries[i] as! [String:Any]
      let dataY = dataXY["data"] as! NSNumber
      let lowerY = dataXY["lower"] as! NSNumber
      let upperY = dataXY["upper"] as! NSNumber
      let dateString = dataXY["date"] as! NSString
      let date = dateFormatter.date(from: dateString as String)
      let timeInterval = date?.timeIntervalSince1970
      let dataEntry = ChartDataEntry.init(x: Double(timeInterval!),
                                          y: Double(truncating: dataY), data: date as AnyObject?)
      chartDataEntryArray2.append(dataEntry)

      let upperEntry = ChartDataEntry.init(x: Double(timeInterval!),
                                           y: Double(truncating: upperY), data: date as AnyObject?)
      upperEntryArray.append(upperEntry)
      
      let lowerEntry = ChartDataEntry.init(x: Double(timeInterval!),
                                           y: Double(truncating: lowerY), data: date as AnyObject?)
      lowerEntryArray.append(lowerEntry)
    }
    updateChartWithData(chartDataEntryArray: chartDataEntryArray,
                        projectionEntryArray: chartDataEntryArray2,
                        upperEntryArray: upperEntryArray,
                        lowerEntryArray: lowerEntryArray)
    
    appBar.addSubviewsToParent()

    nameLabel.text = result["symbol"] as? String
    nameLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(rawValue: 0))
    nameLabel.textColor = UIColor.white
    nameLabel.sizeToFit()
    
    let headerViewHeight = appBar.headerViewController.headerView.frame.size.height
    nameLabel.frame = CGRect(x: 72,
                             y: headerViewHeight - 12,
                             width: nameLabel.frame.size.width,
                             height: 40)
    contentView.addSubview(nameLabel)
    
    priceLabel.text = result["price"] as? String
    priceLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(rawValue: 0))
    priceLabel.textColor = UIColor.white
    priceLabel.textAlignment = .right
    contentView.addSubview(priceLabel)

    priceDescLabel.text = ""
    priceDescLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 0))
    priceDescLabel.textColor = UIColor.white
    priceDescLabel.sizeToFit()
    priceDescLabel.textAlignment = .right
    contentView.addSubview(priceDescLabel)
  }

  func updateChartWithData(chartDataEntryArray: Array<ChartDataEntry>,
    projectionEntryArray: Array<ChartDataEntry>,
    upperEntryArray: Array<ChartDataEntry>,
    lowerEntryArray: Array<ChartDataEntry>) {
    
    let chartDataSet = LineChartDataSet(values: chartDataEntryArray, label: "History")
    chartDataSet.setColor(UIColor.white)
    chartDataSet.drawCirclesEnabled = false
    chartDataSet.drawValuesEnabled = false
    
    let chartDataSet2 = LineChartDataSet(values: projectionEntryArray, label: "Projection")
    chartDataSet2.setColor(UIColor.white)
    chartDataSet2.drawCirclesEnabled = false
    chartDataSet2.drawValuesEnabled = false
    
    let whiteAlpha = UIColor(white: 1, alpha: 0.25)
    let upperDataSet = LineChartDataSet(values: upperEntryArray, label: "Upper")
    upperDataSet.setColor(whiteAlpha)
    upperDataSet.drawCirclesEnabled = false
    upperDataSet.drawValuesEnabled = false
    
    let lowerDataSet = LineChartDataSet(values: lowerEntryArray, label: "Lower")
    lowerDataSet.setColor(whiteAlpha)
    lowerDataSet.drawCirclesEnabled = false
    lowerDataSet.drawValuesEnabled = false
    
    let blue1 = UIColor(
      red: CGFloat(16) / CGFloat(255),
      green: CGFloat(159) / CGFloat(255),
      blue: CGFloat(227) / CGFloat(255),
      alpha: 1)
    let blue2 = UIColor(
      red: CGFloat(16) / CGFloat(255),
      green: CGFloat(159) / CGFloat(255),
      blue: CGFloat(227) / CGFloat(255),
      alpha: 0)
    
    let yellow1 = UIColor(
      red: CGFloat(232) / CGFloat(255),
      green: CGFloat(132) / CGFloat(255),
      blue: CGFloat(33) / CGFloat(255),
      alpha: 1)
    let yellow2 = UIColor(
      red: CGFloat(232) / CGFloat(255),
      green: CGFloat(132) / CGFloat(255),
      blue: CGFloat(33) / CGFloat(255),
      alpha: 0)
    
    let blueColors = [blue2.cgColor, blue1.cgColor] as CFArray
    let blueColorSpace = CGColorSpaceCreateDeviceRGB()
    let blueGradient = CGGradient(colorsSpace: blueColorSpace, colors: blueColors , locations: nil)
    
    let yellowColors = [yellow2.cgColor, yellow1.cgColor] as CFArray
    let yellowColorSpace = CGColorSpaceCreateDeviceRGB()
    let yellowGradient = CGGradient(colorsSpace: yellowColorSpace, colors: yellowColors , locations: nil)
    
    chartDataSet.fillAlpha = 1
    chartDataSet.fill = Fill(linearGradient: blueGradient!, angle: 90)
    chartDataSet.drawFilledEnabled = true
    
    chartDataSet2.fillAlpha = 1
    chartDataSet2.fill = Fill(linearGradient: yellowGradient!, angle: 90)
    chartDataSet2.drawFilledEnabled = true
    
    let chartData =
        LineChartData(dataSets: [chartDataSet, chartDataSet2, upperDataSet, lowerDataSet])
    lineView.data = chartData
    lineView.borderColor = UIColor.white
    lineView.backgroundColor = UIColor.clear
    lineView.noDataTextColor = UIColor.white
    lineView.pinchZoomEnabled = true
    
    let xAxis = lineView.xAxis
    xAxis.labelPosition = .bottomInside
    xAxis.drawAxisLineEnabled = false
    xAxis.drawGridLinesEnabled = false
    xAxis.centerAxisLabelsEnabled = true
    xAxis.labelTextColor = UIColor.white
    xAxis.labelRotationAngle = 45
    xAxis.gridColor = UIColor(white: 1, alpha: 0.1)
    xAxis.valueFormatter = EDSDateValueFormatter()
    
    let leftAxis = lineView.leftAxis
    leftAxis.labelPosition = .insideChart
    leftAxis.drawAxisLineEnabled = false
    leftAxis.drawGridLinesEnabled = true
    leftAxis.centerAxisLabelsEnabled = true
    leftAxis.labelTextColor = UIColor.white
    leftAxis.gridColor = UIColor(white: 1, alpha: 0.1)
    
    let rightAxis = lineView.rightAxis
    rightAxis.enabled = false

    lineView.chartDescription?.enabled = false
    
    let legend = lineView.legend
    legend.enabled = false
    
    lineView.setNeedsLayout()
  }

  override public var childViewControllerForStatusBarHidden: UIViewController? {
    return appBar.headerViewController
  }

  override public var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let lineChartFrame = CGRect(x: -10,
                                y: -10,
                                width: self.view.frame.size.width + 20,
                                height: self.view.frame.size.height + 20);
    self.lineView.frame = lineChartFrame
    priceDescLabel.frame = CGRect(x: 0,
                                  y: 85,
                                  width: self.view.frame.size.width - 50,
                                  height: 40)
    priceLabel.frame = CGRect(x: 0,
                              y: 62,
                              width: self.view.frame.size.width - 50,
                              height: 40)
  }
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
    let message = MDCSnackbarMessage()
    message.text = "Tap on line for price. Pinch to zoom chart.";
    message.duration = 2;
    MDCSnackbarManager.show(message)
  }
  
  public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    priceLabel.text = String(format: "%.2f", entry.y)
    let date = entry.data as! Date
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    priceDescLabel.text = dateFormatter.string(from: date)
  }

}
