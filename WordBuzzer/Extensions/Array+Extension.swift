//
//  Array+Extension.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation

extension Array {
    
    var random: Element? {
        guard self.count > 0 else {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
    
}
