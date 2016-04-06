//
//  SettingsToggleTableViewCell.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-16.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class SettingsToggleTableViewCell: UITableViewCell {


    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    var didToggle: ((toggled:Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func valueChanged(sender: AnyObject) {
        
        if let didToggle = self.didToggle {
            didToggle(toggled: self.toggle.on)
        }
    }
}
