//
//  AboutViewController.swift
//  MemPass
//
//  Created by David Thomas on 2016-03-13.
//  Copyright © 2016 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        self.navigationItem.title = "About"
        
        self.navigationController?.navigationBar.tintColor =
            UIColor.colorFromHex("#EF6340")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        if let html = NSBundle.mainBundle().pathForResource("about", ofType: "html"),
            let string = try? String(contentsOfFile: html, encoding: NSUTF8StringEncoding) {
                webView.loadHTMLString(string, baseURL: nil)
        }
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "AboutView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
