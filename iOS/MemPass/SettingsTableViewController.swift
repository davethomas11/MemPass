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
    
    static var captials:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Capitals"
            cell.toggle.on = opt.hasCapital
        }
    }
    
    static var numbers:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Numbers"
            cell.toggle.on = opt.hasNumber
        }
    }
    
    static var dice:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsToggleTableViewCell {
            cell.label.text = "Include Dice Words"
            cell.toggle.on = opt.hasDiceWords
            
        }
    }
    
    
    static var specialChars:(UITableViewCell,MemPassOptions) -> Void = {
        cell,opt in
        
        if let cell = cell as? SettingsLongTableViewCell {
            cell.label.text = "Sepcial Characters"
            cell.textfield.placeholder = "None"
            cell.textfield.text = opt.getSpecialCharString()
            
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
        }
    }
    
    
}

class SettingsTableViewController: UITableViewController {
    
    var options = MemPass().options
    
    var settings = [
        
        Setting(o: (SettingType.Toggle, SSetups.captials)),
        Setting(o: (SettingType.Toggle, SSetups.numbers)),
        Setting(o: (SettingType.Toggle, SSetups.dice)),
        Setting(o: (SettingType.Long, SSetups.specialChars)),
        Setting(o: (SettingType.Short, SSetups.limitLength))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBarHidden = false
        
        self.navigationItem.title = "Settings"
        
        self.navigationController?.navigationBar.tintColor =
            UIColor.colorFromHex("#ffcc00")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
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
        setting.setup(cell: cell,opts: options)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
