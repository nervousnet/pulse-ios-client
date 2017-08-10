//
//  SettingsTableViewCell.swift
//  SwarmPulse
//
//  Created by Lewin Könemann on 11/12/15.
//  Copyright © 2015 coss.ethz.ch. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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
            pickerView.selectRow(pickerSeconds.index(of: VM.volatility)! , inComponent: 0, animated: true)
        }
        else if (VM.volatility == -1) {
            controlSwitch.setOn(true, animated: true)
            pickerView.selectRow(pickerData.index(of: "forever")! , inComponent: 0, animated: true)
        }
//        storeswitch(controlSwitch)
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("repeater"), userInfo: nil, repeats: true)

        
        // Initialization code
    }
    
    func repeater (){
        NSLog(String(VM.volatility))
    }
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if (controlSwitch.isOn) {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
        }
        else if (!controlSwitch.isOn){
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        }
        else {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case pickerData.index(of: "forever")!:
            VM.setVolatilityVar(-1)
        default:
            VM.setVolatilityVar(pickerSeconds[row])
            
        }
        
    }
    
    @IBAction func storeswitch(_ sender: UISwitch) {
        NSLog(String(pickerView.selectedRow(inComponent: 0)))
        if (sender.isOn) {
            pickerView.isUserInteractionEnabled = true
            switch pickerView.selectedRow(inComponent: 0){
            case pickerData.index(of: "forever")!:
                VM.setVolatilityVar(-1)
            default: VM.setVolatilityVar(pickerSeconds[pickerView.selectedRow(inComponent: 0)])
            }

        }
        else {
            VM.setVolatilityVar(0)
            NSLog("turned off")
            pickerView.isUserInteractionEnabled = false
            
        }
        pickerView.reloadAllComponents()
    }
    
}
