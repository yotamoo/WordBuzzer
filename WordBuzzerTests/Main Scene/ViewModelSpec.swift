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
            
            let viewModelWith: (([Word]) -> Void) = { words in
                wordService = WordServiceMock()
                wordService.wordsForTest = words
                viewModel = ViewModel(wordService: wordService)
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
            
        }
        
    }
    
}
