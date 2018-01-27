//
//  ViewModelSpec.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
@testable import WordBuzzer

class ViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("ViewModel") {
            
            let bag = DisposeBag()
            var wordService: WordServiceMock!
            var viewModel: ViewModeling!
            
            let wordForString: ((String) -> Word) = { str in
                return Word(english: str, spanish: str)!
            }
            
            let viewModelWith: (([Word]?) -> Void) = { words in
                wordService = WordServiceMock()
                wordService.wordsForTest = words
                viewModel = ViewModel(wordService: wordService)
            }
            
            describe("startAnimating") {
                
                it("does not emit value before viewWillAppear") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: Word? = nil
                    viewModel.startAnimating.subscribe(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventually(beNil())
                }
                
                it("does not emit value if word array is nil") {
                    viewModelWith(nil)
                    var actual: Word? = nil
                    viewModel.startAnimating.subscribe(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventually(beNil())
                }
                
                it("does not emit value if word array is not nil but empty") {
                    viewModelWith([Word]())
                    var actual: Word? = nil
                    viewModel.startAnimating.subscribe(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventually(beNil())
                }
                
                it("does emits a word after viewWillAppear") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: Word? = nil
                    viewModel.startAnimating.subscribe(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventuallyNot(beNil())
                    expect(actual) == word
                }
                
            }
            
            describe("centerLabelText") {
                
                it("does not emit value before viewWillAppear") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.centerLabelText.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventually(beNil())
                }
                
                it("does not emit value if word array is nil") {
                    viewModelWith(nil)
                    var actual: String? = nil
                    viewModel.centerLabelText.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventually(beNil())
                }
                
                it("does not emit value if word array is empty") {
                    viewModelWith([Word]())
                    var actual: String? = nil
                    viewModel.centerLabelText.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventually(beNil())
                }
                
                it("returns selects a word") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.centerLabelText.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    viewModel.viewWillAppear.onNext(())
                    expect(actual).toEventuallyNot(beNil())
                    expect(actual) == expected
                }
                
            }
            
            describe("leftPlayerScore") {
                
                it("always starts with 0") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.leftPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    expect(actual) == "0"
                }
                
                it("increases result when left player wins") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.leftPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    viewModel.viewWillAppear.onNext(())
                    viewModel.leftBuzzerTapped.onNext(())
                    expect(actual) == "1"
                }
                
                it("does not increases result when right player wins") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.leftPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    viewModel.viewWillAppear.onNext(())
                    viewModel.rightBuzzerTapped.onNext(())
                    expect(actual) == "0"
                }
                
            }
            
            describe("rightPlayerScore") {
                
                it("always starts with 0") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.rightPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    expect(actual) == "0"
                }
                
                it("increases result when right player wins") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.rightPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    viewModel.viewWillAppear.onNext(())
                    viewModel.rightBuzzerTapped.onNext(())
                    expect(actual) == "1"
                }
                
                it("does not increases result when left player wins") {
                    let expected = "uno"
                    let word = wordForString(expected)
                    viewModelWith([word])
                    var actual: String? = nil
                    viewModel.rightPlayerScore.drive(onNext: {
                        actual = $0
                    }).disposed(by: bag)
                    expect(actual).toEventuallyNot(beNil())
                    viewModel.viewWillAppear.onNext(())
                    viewModel.leftBuzzerTapped.onNext(())
                    expect(actual) == "0"
                }
                
            }
            
        }
        
    }
    
}
