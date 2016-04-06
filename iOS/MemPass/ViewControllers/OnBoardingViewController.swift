//
//  OnBoardingViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-14.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoApp:"))
        self.navigationController?.navigationBarHidden = true
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "tellUserToTap", userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "OnBoardingView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])    }
    
    func tellUserToTap() {
        self.view.makeToast("Tap the screen to begin!")
    }
    
    func gotoApp(sender: UITapGestureRecognizer) {
        
        let loc = sender.locationInView(self.view)
        self.navigationController?.radialPushViewController(R.storyboard.main.swReveal, x: loc.x, y: loc.y, comlititionBlock: {})
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

}
