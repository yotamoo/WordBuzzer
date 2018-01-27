//
//  WordServiceMock.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
@testable import WordBuzzer

class WordServiceMock: WordServicing {
    
    var wordsForTest: [Word]?
    var words: Observable<[Word]?> {
        return Observable.just(self.wordsForTest)
    }
    
}
