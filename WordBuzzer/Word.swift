//
//  Word.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation

struct Word {
    
    let english: String
    let spanish: String
    
    init?(english: String?, spanish: String?) {
        guard let english = english, let spanish = spanish else {
            return nil
        }
        self.english = english
        self.spanish = spanish
    }
    
}

extension Word: Equatable {
 
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.english == rhs.english && lhs.spanish == rhs.spanish
    }
    
}
