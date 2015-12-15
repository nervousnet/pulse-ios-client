//
//  SettingsTableViewCell.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 11/12/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var controlSwitch: UISwitch!
    let VM = PulseVM.sharedInstance
    
    var pickerData : [String] = ["1 day","10 days","30 days","6 months","1 year","2 years","5 years","10 years","forever"]
    var pickerSeconds : [Int] = [86400,864000,2592000,15552000,31104000,62208000,155520000,311040000]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        if (VM.volatility == 0){
            controlSwitch.setOn(false, animated: true)
        }
        else if (VM.volatility >= pickerSeconds.first! && VM.volatility <= pickerSeconds.last){
            controlSwitch.setOn(true, animated: true)
            pickerView.selectRow(pickerSeconds.indexOf(VM.volatility)! , inComponent: 0, animated: true)
        }
        else if (VM.volatility == -1) {
            controlSwitch.setOn(true, animated: true)
            pickerView.selectRow(pickerData.indexOf("forever")! , inComponent: 0, animated: true)
        }
//        storeswitch(controlSwitch)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("repeater"), userInfo: nil, repeats: true)

        
        // Initialization code
    }
    
    func repeater (){
        NSLog(String(VM.volatility))
    }
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if (controlSwitch.on) {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        else if (!controlSwitch.on){
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.darkGrayColor()])
        }
        else {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case pickerData.indexOf("forever")!:
            VM.setVolatilityVar(-1)
        default:
            VM.setVolatilityVar(pickerSeconds[row])
            
        }
        
    }
    
    @IBAction func storeswitch(sender: UISwitch) {
        NSLog(String(pickerView.selectedRowInComponent(0)))
        if (sender.on) {
            pickerView.userInteractionEnabled = true
            switch pickerView.selectedRowInComponent(0){
            case pickerData.indexOf("forever")!:
                VM.setVolatilityVar(-1)
            default: VM.setVolatilityVar(pickerSeconds[pickerView.selectedRowInComponent(0)])
            }

        }
        else {
            VM.setVolatilityVar(0)
            NSLog("turned off")
            pickerView.userInteractionEnabled = false
            
        }
        pickerView.reloadAllComponents()
    }
    
}
