//
//  PieChartView.swift
//  KeepAccounts
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

private let sepLineHeight:CGFloat = 0.5
private let rotateBtnWidth:CGFloat = 60
private let rotateBtnMarginBottom:CGFloat = 10
private let redIndicatorHeight:CGFloat = 30
private let midRoundBtnWidth:CGFloat = 40
private let titleLabelY:CGFloat = 50
private let titleLabelHeight:CGFloat = 50
private let moneyLabelHeight:CGFloat = 50

class PieChartView: UIView {
    
    //MARK: - properties (public)
    var lineWidth:CGFloat = 15
    var index:Int = 1
    weak var delegate:AKPickerViewDelegate?
    weak var dataSource:AKPickerViewDataSource?
    
    var pieChartTotalCost:String{
        get{
            return costBtn.titleLabel?.text ?? ""
        }
        set(newValue){
            costBtn.setTitle("总收入\n\(newValue)", forState: .Normal)
        }
    }
    
    var pieChartTotalIncome:String{
        get{
            return incomeBtn.titleLabel?.text ?? ""
        }
        set(newValue){
            incomeBtn.setTitle("总支出\n\(newValue)", forState: .Normal)
        }
    }
    
    var pieChartItemTitle:String{
        get{
            return itemTitleLabel.text ?? ""
        }
        set(newValue){
            itemTitleLabel.text = newValue
        }
    }
    
    var pieChartItemMoney:String{
        get{
            return itemMoneyLabel.text ?? ""
        }
        set(newValue){
            itemMoneyLabel.text = newValue
        }
    }
    
    //MARK: - properties (private)
    private var incomeBtn:UIButton!
    private var costBtn:UIButton!
    private var itemTitleLabel:UILabel!
    private var itemMoneyLabel:UILabel!
    private var itemIconBtn:UIButton!
    private var itemPercentage:UILabel!
    private var itemAccountCount:UILabel!
    private var rotateBtn:UIButton!
    private var pickerView:AKPickerView!
    
    private var dataItem:Array<CGFloat>
    
    private var itemValueAmount:CGFloat{
        var amount:CGFloat = 0
        for value in dataItem{
            amount += value
        }
        return amount
    }
    private var containerLayer:CAShapeLayer!
    
    private var radius:CGFloat {
        return self.frame.width / 4
    }
    private var layerWidth:CGFloat{
        return self.frame.width / 2
    }
    
    //MARK: - init
    init(frame:CGRect, dataItem:Array<CGFloat>, delegate:AKPickerViewDelegate!, dataSource:AKPickerViewDataSource!){
        self.dataSource = dataSource
        self.delegate = delegate
        self.dataItem = dataItem
        super.init(frame: frame)
        setupViews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - operations (internal)
    func reDraw(index:Int){
        var curIndex = index - 1
        if index == 0{
            curIndex = dataItem.count - 1
        }
        
        var rotateRadian = dataItem[curIndex] / itemValueAmount + dataItem[index] / itemValueAmount
        rotateRadian = -rotateRadian * CGFloat(M_PI)
        rotateContainerLayerWithRadian(rotateRadian)
    }
    
    func rotateAction(sender:UIButton){
        reDraw(index % dataItem.count)
        index += 1
    }
    
    func selectedIncome(sender:UIButton){
        sender.selected = !sender.selected
        costBtn.selected = !sender.selected
    }
    func selectedCost(sender:UIButton){
        sender.selected = !sender.selected
        incomeBtn.selected = !sender.selected
    }
    
    //MARK: - setupViews (private)
    private func setupViews(frame:CGRect){
        let incomeAndCostBtnHeight:CGFloat = 80
        let layersHeight = frame.height - 2 * incomeAndCostBtnHeight
        
        setupIncomeAndCostBtn(CGRectMake(0, 0, frame.width, incomeAndCostBtnHeight))
        setupScrollMonthView(CGRectMake(0, incomeAndCostBtnHeight, frame.width, incomeAndCostBtnHeight))
        setupRotateLayers(CGRectMake(0, incomeAndCostBtnHeight * 2, frame.width, layersHeight))
    }
    
    private  func setupIncomeAndCostBtn(frame:CGRect){
        
        let btnWidth:CGFloat = 75
        let btnMargin:CGFloat = 15
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = UIColor(hue: 0.7, saturation: 0.3, brightness: 0.4, alpha: 1.0)
        
        let incomeBtn = createBtn(CGRectMake(btnMargin, btnMargin, btnWidth, btnWidth), title:"总收入\n9384.00", action:"selectedIncome:")
        self.incomeBtn = incomeBtn
        let costBtn = createBtn(CGRectMake(frame.width - btnMargin - btnWidth, btnMargin, btnWidth, btnWidth), title:"总支出\n9384.00", action:"selectedCost:")
        costBtn.titleLabel?.textAlignment = .Right
        costBtn.selected = true
        self.costBtn = costBtn
        let sepline = UIView(frame: CGRectMake(0, frame.height, frame.width, sepLineHeight))
        sepline.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        bgView.addSubview(sepline)
        bgView.addSubview(incomeBtn)
        bgView.addSubview(costBtn)
        self.addSubview(bgView)
    }
    private func createBtn(frame:CGRect, title:String, action:Selector)->UIButton{
        let btn = UIButton(frame: frame)
        btn.setTitle(title, forState: .Normal)
        btn.titleLabel?.numberOfLines = 2
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: .Selected)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    private  func setupScrollMonthView(frame:CGRect){
        
        let pickerView = AKPickerView(frame: frame)
        pickerView.delegate = delegate
        pickerView.dataSource = dataSource
        
        pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        pickerView.pickerViewStyle = .Wheel
        pickerView.maskDisabled = false
        pickerView.interitemSpacing = 20
        pickerView.reloadData()
        pickerView.backgroundColor = UIColor(hue: 0.4, saturation: 0.5, brightness: 0.6, alpha: 1.0)
        self.pickerView = pickerView
        
        let sepline = UIView(frame: CGRectMake(0, frame.height * 2, frame.width, sepLineHeight))
        sepline.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        
        self.addSubview(pickerView)
        self.addSubview(sepline)
    }
    
    private  func setupRotateLayers(frame:CGRect){
        
        
        let bgView = UIView(frame: frame)
//        bgView.backgroundColor = UIColor(hue: 0.4, saturation: 0.5, brightness: 0.6, alpha: 1.0)
        
        let titleLabel = UILabel(frame: CGRectMake(frame.width/2 - titleLabelHeight, titleLabelY, titleLabelHeight * 2, titleLabelHeight))
        titleLabel.textAlignment = .Center
        titleLabel.text = "零钱"
        let moneyLabel = UILabel(frame: CGRectMake(0, 0, moneyLabelHeight * 2, moneyLabelHeight))
        moneyLabel.text = "890.99"
        moneyLabel.textAlignment = .Center
        moneyLabel.center = CGPointMake(frame.width/2, titleLabelHeight + titleLabelY)
        itemMoneyLabel = moneyLabel
        itemTitleLabel = titleLabel
        
        let redIndicator = UIView(frame: CGRectMake(0, 0, 1, redIndicatorHeight))
        redIndicator.center = CGPointMake(frame.width/2, frame.height/2 - frame.width/4 - redIndicatorHeight )
        redIndicator.backgroundColor = UIColor.redColor()
        
        
        let midRoundBtn = UIButton(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        midRoundBtn.center = CGPointMake(frame.width/2, frame.height/2 - midRoundBtnWidth/2)
        midRoundBtn.setImage(UIImage(named: "type_big_1"), forState: .Normal)
        itemIconBtn = midRoundBtn
        let midPercentLabel = UILabel(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        midPercentLabel.center = CGPointMake(frame.width/2, frame.height/2 + midRoundBtnWidth/2)
        midPercentLabel.text = "15%"
        midPercentLabel.textAlignment = .Center
        itemPercentage = midPercentLabel
        
        containerLayer = CAShapeLayer()
        containerLayer.frame = CGRectMake(0, 0, frame.width, frame.height)
        var percentageStart:CGFloat = 0
        var percentageEnd:CGFloat = 0
        for i in 0...dataItem.count - 1{
            percentageEnd += dataItem[i] / itemValueAmount
            let pieLayer = generateLayers(frame, percentageStart: percentageStart, percentageEnd: percentageEnd)
            containerLayer.addSublayer(pieLayer)
            percentageStart = percentageEnd
        }
        gradientMaskAnimation(frame)
        let initRotateRadian = -CGFloat(M_PI) * dataItem[0] / itemValueAmount
        rotateContainerLayerWithRadian(initRotateRadian)
        
        
        let countLabel = UILabel(frame: CGRectMake(0, 0, midRoundBtnWidth, midRoundBtnWidth))
        countLabel.center = CGPointMake(frame.width/2, frame.height/2 + frame.width/4 + 40)
        countLabel.textAlignment = .Center
        countLabel.text = "2笔"
        itemAccountCount = countLabel
        
        let rotateBtnX = (frame.width - rotateBtnWidth) / 2
        let rotateBtnY =  frame.height - rotateBtnMarginBottom - rotateBtnWidth
        let rotateBtn = UIButton(frame: CGRectMake(rotateBtnX, rotateBtnY, rotateBtnWidth, rotateBtnWidth))
        rotateBtn.setImage(UIImage(named: "btn_pieChart_rotation"), forState: .Normal)
        rotateBtn.addTarget(self, action: "rotateAction:", forControlEvents: .TouchUpInside)
        
        
        bgView.layer.addSublayer(containerLayer)
        bgView.addSubview(countLabel)
        bgView.addSubview(midPercentLabel)
        bgView.addSubview(midRoundBtn)
        bgView.addSubview(moneyLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(redIndicator)
        bgView.addSubview(rotateBtn)
        self.addSubview(bgView)
    }
    
    private func gradientMaskAnimation(frame:CGRect){
        
        containerLayer.mask = generateLayers(frame, percentageStart: 0, percentageEnd: 1)
        let gradientAnimation = CABasicAnimation(keyPath: "strokeEnd")
        gradientAnimation.fromValue = 0
        gradientAnimation.toValue = 1
        gradientAnimation.duration = 0.5
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        containerLayer.mask?.addAnimation(gradientAnimation, forKey: "gradientAnimation")
    }
    
    private func generateLayers(frame: CGRect, percentageStart:CGFloat, percentageEnd:CGFloat) -> CAShapeLayer{
        
        let path = UIBezierPath(arcCenter: CGPointMake(radius, radius), radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(3 * M_PI_2) , clockwise: true)
        let pieLayer = CAShapeLayer()
        pieLayer.path = path.CGPath
        pieLayer.frame = CGRectMake(0, 0, layerWidth, layerWidth)
        pieLayer.position = CGPointMake(frame.width / 2, frame.height / 2)
        pieLayer.lineWidth = lineWidth
        pieLayer.strokeColor = UIColor(hue: percentageEnd, saturation: 0.5, brightness: 0.75, alpha: 1.0).CGColor
        pieLayer.fillColor = nil
        pieLayer.strokeStart = percentageStart
        pieLayer.strokeEnd = percentageEnd
        return pieLayer
    }
    
    private func rotateContainerLayerWithRadian(radian:CGFloat){
        
        let myAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let myRotationTransform = CATransform3DRotate(containerLayer.transform, radian, 0, 0, 1)
        if let rotationAtStart = containerLayer.valueForKeyPath("transform.rotation") {
            
            myAnimation.fromValue = rotationAtStart.floatValue
            myAnimation.toValue = CGFloat(rotationAtStart.floatValue) + radian
        }
        containerLayer.transform = myRotationTransform
        myAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        containerLayer.addAnimation(myAnimation, forKey: "transform.rotation")
    }

}
