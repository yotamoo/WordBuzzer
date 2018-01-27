//
//  WordSpec.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import WordBuzzer

class WordSpec: QuickSpec {
    
    override func spec() {
        
        describe("Word") {
            
            it("correctly initializes") {
                var word = Word(english: "a", spanish: nil)
                expect(word).to(beNil())
                word = Word(english: nil, spanish: "a")
                expect(word).to(beNil())
                word = Word(english: nil, spanish: nil)
                expect(word).to(beNil())
                word = Word(english: "english", spanish: "spanish")
                expect(word).toNot(beNil())
                expect(word?.english) == "english"
                expect(word?.spanish) == "spanish"
            }
            
        }
        
    }
    
}
