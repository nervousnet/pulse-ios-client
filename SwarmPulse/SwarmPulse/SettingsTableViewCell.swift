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
    
    var pickerData : [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerData = ["1 day","10 days","30 days","6 months","1 year","2 years","5 years","10 years","forever"]
        
        // Initialization code
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
        return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
}
