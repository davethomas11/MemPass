//
//  SideBarTableControllerTableViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-15.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class SideBarOption {
    var title:String
    var action:()->Void
    
    init(title:String, action:()->Void) {
        self.title = title
        self.action = action
    }
}

class SideBarAction {
    static var gotoSeeed:()->Void = {
        
        if let window = UIApplication.sharedApplication().keyWindow, let n =
            window.rootViewController as? UINavigationController, let vc = R.storyboard.main.seedView {
                
                n.pushViewController(vc, animated: true)
        }
        
    }
    
    
    static var gotoSettings:()->Void = {
        
        if let window = UIApplication.sharedApplication().keyWindow, let n =
            window.rootViewController as? UINavigationController, let vc = R.storyboard.main.settings {
                
                n.pushViewController(vc, animated: true)
        }
        
    }
}

class SideBarTableControllerTableViewController: UITableViewController {

    var options = [
        
        SideBarOption(title: "What is this?", action: {}),
        SideBarOption(title: "Syncing to Desktop", action: {}),
        SideBarOption(title: "Seed", action: SideBarAction.gotoSeeed),
        SideBarOption(title: "Settings", action: SideBarAction.gotoSettings)
        
        
        ]
    
    
    
    
    static func createItemAction(vc:UIViewController?) -> ()->Void {
        
        return {
            
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
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
        return options.count
    }
    
    

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sideBarItem", forIndexPath: indexPath) as! SideBarTableViewCell
        
        cell.label.text = options[indexPath.row].title
        let bg = UIView(frame: cell.bounds)
        bg.backgroundColor = UIColor.colorFromHex("#230b07")
        bg.alpha = 0.75
        cell.selectedBackgroundView = bg

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.revealViewController().rightRevealToggleAnimated(true)
        options[indexPath.row].action()
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
