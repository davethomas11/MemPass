//
//  OnBoarding1ViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-13.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class OnBoarding1ViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var pw1: UILabel!
    @IBOutlet weak var pw2: UILabel!
    @IBOutlet weak var pw3: UILabel!
    

    var __text:String?
    var __pw1:String?
    var __pw2:String?
    var __pw3:String?
    var __font:UIFont?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if let text = __text {
            self.text.text = text
        }
        
        if let p1 = __pw1 {
            self.pw1.text = p1
        }
        
        if let p2 = __pw2 {
            self.pw2.text = p2
        }
        
        if let p3 = __pw3 {
            self.pw3.text = p3
        }
        
        if let font = __font {
            self.text.font = font
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func next(sender: AnyObject) {
        
        if let obpvc = self.parentViewController?.parentViewController as? OnBoardingPageViewController {
            
            obpvc.next()
        }
        
    }
}
