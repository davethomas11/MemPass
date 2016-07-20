//
//  SettingsTableViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-16.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

enum SettingType {
    case Toggle, Long, Short
    
    func reUseId() -> String {
        switch self {
        case .Toggle:
            return R.reuseIdentifier.switchCell.identifier
        case .Short:
            return R.reuseIdentifier.singleValue.identifier
        case .Long:
            return R.reuseIdentifier.textCell.identifier
            
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .Toggle, .Short:
            return 75
        case .Long:
            return 100
            
        }
    }
}

class Setting {
  
    var type:SettingType = .Toggle
    var setup:(cell:UITableViewCell,opts:MemPassOptions)->Void = {_ in}
    
    init(o:(SettingType,(UITableViewCell,MemPassOptions)->Void)) {
        
        self.type = o.0
        self.setup = o.1
    }
}

class SSetups {
    
    static var limitBeforeDice:(UITableViewCell, MemPassOptions) -> Void = {
        cell, opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Limit Before Dice"
            cell.toggle.on = opt.applyLimitBeforeDice
            
            cell.didToggle = {
                toggled in
                
                opt.applyLimitBeforeDice = toggled
                opt.saveDefault();
            }
        }
    }
    
    static var captials:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Capitals"
            cell.toggle.on = opt.hasCapital
            
            cell.didToggle = {
                toggled in
                
                opt.hasCapital = toggled
                opt.saveDefault();
            }
        }
    }
    
    static var numbers:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Numbers"
            cell.toggle.on = opt.hasNumber
            
            cell.didToggle = {
                toggled in
                
                opt.hasNumber = toggled
                opt.saveDefault();
            }
        }
    }
    
    static var dice:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Dice Words"
            cell.toggle.on = opt.hasDiceWords
            
            cell.didToggle = {
                toggled in
                
                opt.hasDiceWords = toggled
                opt.saveDefault();
            }
            
        }
    }
    
    
    static var specialChars:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsLongTableViewCell {
            cell.label.text = "Sepcial Characters"
            cell.textfield.placeholder = "None"
            cell.textfield.text = opt.getSpecialCharString()
            
            cell.textChanged = {
                value in
                
                opt.setSpecialCharString(value)
                opt.saveDefault()
            }
            
        }
    }
    
    static var limitLength:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsSingleValueTableViewCell {
            cell.label.text = "Pass Length Limit"
            cell.textfield.placeholder = "No"
            if opt.characterLimit > 0 {
                cell.textfield.text = "\(opt.characterLimit)"
            }
            cell.textfield.keyboardType = UIKeyboardType.NumberPad
            
            cell.textChanged = {
                value in
                
                if let v = value, i = Int(v) {
                    opt.characterLimit = i
                    opt.saveDefault()
                }
            }
        }
    }
    
    
}

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var options = MemPass.sharedInstance().options
    
    var settings = [
        
        
        Setting(o: (SettingType.Toggle, SSetups.captials)),
        Setting(o: (SettingType.Toggle, SSetups.numbers)),
        Setting(o: (SettingType.Toggle, SSetups.dice)),
        Setting(o: (SettingType.Toggle, SSetups.limitBeforeDice)),
        Setting(o: (SettingType.Long, SSetups.specialChars)),
        Setting(o: (SettingType.Short, SSetups.limitLength)),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.resignText)))
        self.view.userInteractionEnabled = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTableViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTableViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification:NSNotification) {
        
        if let info = notification.userInfo as? Dictionary<String,AnyObject>,
            let rect = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            
            let size = rect.size
            let contentInsets = UIEdgeInsetsMake(0, 0, size.height, 0)
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            
            var rect = self.view.frame
            rect.size.height -= size.height;
            if (!CGRectContainsRect(rect, <#T##rect2: CGRect##CGRect#>))
        }
        
    }
    
    func keyboardWillHide(notification:NSNotification) {
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        
        self.navigationItem.title = "Settings"
        
        self.navigationController?.navigationBar.tintColor =
            UIColor.colorFromHex("#EF6340")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "SettingsView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    func resignText() {
      
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let setting = settings[indexPath.row]
        return setting.type.height()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let setting = settings[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(setting.type.reUseId(), forIndexPath: indexPath)
        setting.setup(cell: cell, opts: options)
        
        if let settingCell = cell as? SettingsTextProtocol {
            settingCell.getTextField().delegate = self
        }
        
        return cell
    }
    
    
}
