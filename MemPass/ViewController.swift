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

    
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var copyToClipbaord: UIButton!
    
    
    var memPasser:MemPass = MemPass()
    var password:String?
    var passHidden = false
    
    let passReady:String = "Password Ready"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let resultTap = UITapGestureRecognizer(target: self, action: "tapResult")
        memPassResult.addGestureRecognizer(resultTap)
        memPassResult.userInteractionEnabled = true
        
        self.view.backgroundColor = UIColor.gradientFromColor(UIColor.colorFromHex("#4f4a39"), toColor: UIColor.colorFromHex("#685f43"), withHeight: Int(self.view.bounds.height))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignText"))
        self.view.userInteractionEnabled = true
        
        if let font = UIFont(name: "Share-TechMono", size: 22) {
        
            memPass.attributedPlaceholder = NSAttributedString(string: "Enter a simple phrase",
                attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font])
        }
        
        showPassword.layer.cornerRadius = showPassword.bounds.height / 2
        copyToClipbaord.layer.cornerRadius = copyToClipbaord.bounds.height / 2
        showPassword.hidden = true
        copyToClipbaord.hidden = true
        
        self.navigationController?.navigationBarHidden = true
        
        memPassTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapTitle:"))
        
    }
    
    func tapTitle(send: UITapGestureRecognizer) {
        
        let loc = send.locationInView(self.view)
        self.navigationController?.radialPopViewController(self, x: loc.x, y: loc.y, comlititionBlock: {})
        
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
            
            self.view.makeToast("Generated unique password for your phrase and your device")
            
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
    
    @IBAction func reSeed(sender: AnyObject) {
        
        let confirm = UIAlertController(title: "ReSeed", message: "Reseed your passwords?", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirm.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            [weak self]_ in
            
            self?.memPasser.reSeed()
            self?.memPassIt()
        }))
        
        confirm.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(confirm, animated: true, completion: nil)
    }
    
    func tapResult() {
        
        if !passHidden {
            memPassResult.selectAll(self)
        }
    }
}

