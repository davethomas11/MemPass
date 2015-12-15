//
//  ReplaceVCSegue.swift
//  Rankzoo
//
//  Created by Jerry Tsai on 2015-07-14.
//  Copyright (c) 2015 Assembly Co. All rights reserved.
//

import UIKit

class ReplaceVCSegue: UIStoryboardSegue {
   
    
    override func perform() {
        let sourceVC: UIViewController = self.sourceViewController 
        let destinationVC: UIViewController = self.destinationViewController 
        let navController: UINavigationController = sourceVC.navigationController!
        
        navController.popToRootViewControllerAnimated(false)
        navController.pushViewController(destinationVC, animated: true)
    }
}
