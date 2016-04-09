//
//  SettingsCellProtocol.swift
//  MemPass
//
//  Created by David Thomas on 2016-03-12.
//  Copyright © 2016 Dave Anthony Thomas. All rights reserved.
//

import Foundation

protocol SettingsCellProtocol {
    
    func resignTextField()
    func isCurrentlyActive() -> Bool
}