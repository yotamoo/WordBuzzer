//
//  WordServiceMock.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
@testable import WordBuzzer

class WordServiceMock: WordServicing {
    
    var wordsForTest: [Word]?
    var words: [Word]? {
        return self.wordsForTest
    }
    
}
