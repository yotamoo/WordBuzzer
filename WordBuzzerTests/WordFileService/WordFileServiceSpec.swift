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
import RxSwift
@testable import WordBuzzer

class WordFileServiceSpec: QuickSpec {
    
    override func spec() {
        
        let bundle = Bundle(for: type(of: self))
        let bag = DisposeBag()
        
        describe("WordFileService") {
            
            it("returns a nil array if file name is wrong") {
                let service = WordFileService(fileName: "NonExistingFile", bundle: bundle)
                var words: [Word]?
                service.words.subscribe(onNext: {
                    words = $0
                }).disposed(by: bag)
                expect(words).to(beNil())
            }
            
            it("returns a nil array if json is corrupted") {
                let service = WordFileService(fileName: "Invalid", bundle: bundle)
                var words: [Word]? = [Word(english: "sadf", spanish: "asdf")!]
                service.words.subscribe(onNext: {
                    words = $0
                }).disposed(by: bag)
                expect(words).toEventually(beNil())
            }
            
            it("returns an empty array if json has one") {
                let service = WordFileService(fileName: "Empty", bundle: bundle)
                var words: [Word]?
                service.words.subscribe(onNext: {
                    words = $0
                }).disposed(by: bag)
                expect(words).toEventuallyNot(beNil())
                expect(words?.isEmpty).toEventually(beTrue())
            }
            
            it("can parse a valid json file") {
                let service = WordFileService(fileName: "Valid", bundle: bundle)
                var words: [Word]?
                service.words.subscribe(onNext: {
                    words = $0
                }).disposed(by: bag)
                expect(words).toEventuallyNot(beNil())
                expect(words?.first) == Word(english: "one", spanish: "one")
                expect(words?.last) == Word(english: "two", spanish: "two")
            }
            
            it("does not run on the main thread") {
                let service = WordFileService(fileName: "Valid", bundle: bundle)
                service.words.subscribe(onNext: { _ in
                    if Thread.isMainThread {
                        fail("should not run on main thread")
                    }
                }).disposed(by: bag)
            }
            
        }
        
    }
    
}
