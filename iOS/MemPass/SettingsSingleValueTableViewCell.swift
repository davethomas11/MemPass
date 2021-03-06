//
//  SettingsSingleValueTableViewCell.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-16.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class SettingsSingleValueTableViewCell: UITableViewCell,  SettingsTextProtocol {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var textChanged: ((value:String?) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

    func valueChanged() {
        if let textChanged = self.textChanged {
            textChanged(value: textfield.text)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        valueChanged()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
    
   
    func getTextField() -> UITextField {
        return textfield
    }
   
}
