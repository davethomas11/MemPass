//
//  SeedViewController.swift
//  MemPass
//
//  Created by David Thomas on 2015-12-11.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

import UIKit

class SeedViewController: UIViewController {

    @IBOutlet weak var QRImage: UIImageView!
    var memPass:MemPass = MemPass()
    
    override func viewDidLoad() {
        
        let qr = QRCode(memPass.seed)
        QRImage.image = qr?.image
    }
}
