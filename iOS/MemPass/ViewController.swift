//
//  ViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-10.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var memPass: UITextField!
    @IBOutlet weak var memPassResult: UITextView!
    
    @IBOutlet weak var memPassTitle: UILabel!

    @IBOutlet weak var memPassMenuButton: UIButton!
    
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var copyToClipbaord: UIButton!
    
    @IBOutlet weak var buttonTouchArea: UIView!
    
    var memPasser:MemPass = MemPass.sharedInstance()
    var password:String?
    var passHidden = false
    
    let passReady:String = "Password Ready"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let resultTap = UITapGestureRecognizer(target: self, action: "tapResult")
        memPassResult.addGestureRecognizer(resultTap)
        memPassResult.userInteractionEnabled = true
        
        //685f43
        self.view.backgroundColor = UIColor.gradientFromColor(UIColor.colorFromHex("#292d33"), toColor: UIColor.colorFromHex("#3fb2ee"), withHeight: Int(self.view.bounds.height))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignText"))
        self.view.userInteractionEnabled = true
        
        if let font = UIFont(name: "Share-TechMono", size: 22) {
        
            memPass.attributedPlaceholder = NSAttributedString(string: "Enter a simple phrase",
                attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font])
        }
        
        showPassword.layer.cornerRadius = 5
        copyToClipbaord.layer.cornerRadius = 5
        showPassword.hidden = true
        copyToClipbaord.hidden = true
        
        self.navigationController?.navigationBarHidden = true
        
        memPassTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapTitle:"))
        
        if let reveal = self.revealViewController() {
            
            self.memPassMenuButton.addTarget(reveal, action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(reveal.panGestureRecognizer())
         
            buttonTouchArea.userInteractionEnabled = true
            buttonTouchArea.addGestureRecognizer(UITapGestureRecognizer(target: reveal, action: "rightRevealToggle:"))
        }
        
        
    }
    
    
    
   
    
    func tapTitle(send: UITapGestureRecognizer) {
        
        let loc = send.locationInView(self.view)
        if let  nc = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController {
            nc.radialPopViewController(self, x: loc.x, y: loc.y, comlititionBlock: {})
        }
        
    }
    
    func clear() {
        
        showPassword.hide() {
            [weak self] in self?.showPassword.setTitle("Show", forState: UIControlState.Normal)
        }
        copyToClipbaord.hide()
        
    
        password = ""
        passHidden = true
        memPass.text = ""
        memPassResult.text = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        
        copyToClipbaord.hidden = true
        showPassword.hidden = true
        
        password = ""
        passHidden = true
        memPass.text = ""
        memPassResult.text = ""
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "MemPassView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func resignText () {
        memPass.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        clear()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let t = memPass.text where t.isEmpty {
            clear()
        } else {
            
            memPassIt()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        memPass.resignFirstResponder()
        return true
    }
    
    func memPassIt() -> Bool {
        if let text = memPass.text where !text.isEmpty {
            
            password = memPasser.generate(text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            memPassResult.text = passReady
            memPass.resignFirstResponder()
            
            showPassword.show()
            copyToClipbaord.show()
            passHidden = true
            showPassword.setTitle("Show", forState: UIControlState.Normal)
            
            return true
        }
        
        return false
    }
    
    @IBAction func showPassword(sender: AnyObject) {
        
        if passHidden {
            memPassResult.text = password
            showPassword.setTitle("Hide", forState: UIControlState.Normal)
        } else {
            memPassResult.text = passReady
            showPassword.setTitle("Show", forState: UIControlState.Normal)
        }
        
        passHidden = !passHidden
        
    }

    
    @IBAction func copyToClipboard(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = password
        self.view.makeToast("Password copied to clipboard")
    }
    
    /**/
    
    func tapResult() {
        
        if !passHidden {
            memPassResult.selectAll(self)
        }
    }
}

