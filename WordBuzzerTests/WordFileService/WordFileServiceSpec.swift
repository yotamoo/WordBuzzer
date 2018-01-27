//
//  WordFileServiceSpec.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import WordBuzzer

class WordFileServiceSpec: QuickSpec {
    
    override func spec() {
        
        let bundle = Bundle(for: type(of: self))
        
        describe("WordFileService") {
            
            it("returns a nil array if file name is wrong") {
                let service = WordFileService(fileName: "NonExistingFile", bundle: bundle)
                let words = service.words
                expect(words).to(beNil())
            }
            
            it("returns a nil array if json is corrupted") {
                let service = WordFileService(fileName: "Invalid", bundle: bundle)
                let words = service.words
                expect(words).to(beNil())
            }
            
            it("returns an empty array if json has one") {
                let service = WordFileService(fileName: "Empty", bundle: bundle)
                let words = service.words
                expect(words).toNot(beNil())
                expect(words?.isEmpty).to(beTrue())
            }
            
            it("can parse a valid json file") {
                let service = WordFileService(fileName: "Valid", bundle: bundle)
                let words = service.words
                expect(words).toNot(beNil())
                expect(words?.first) == Word(english: "one", spanish: "one")
                expect(words?.last) == Word(english: "two", spanish: "two")
            }
            
        }
        
    }
    
}
