//
//  ReplaceSplashVCSegue.swift
//  Rankzoo
//
//  Created by Jerry Tsai on 2015-07-14.
//  Copyright (c) 2015 Assembly Co. All rights reserved.
//

import UIKit

class ReplaceRootVCSegue: UIStoryboardSegue {
    
    override func perform() {
        self.sourceViewController.navigationController?.setViewControllers([self.destinationViewController], animated: true)
    }
}
