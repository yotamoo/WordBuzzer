//
//  ViewControllerSpec.swift
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

class ViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("ViewController") {
            
            var vc: ViewController!
            var viewModel: ViewModelMock!
            
            beforeEach {
                let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
                vc = storyboard.instantiateInitialViewController() as! ViewController
                viewModel = ViewModelMock()
                vc.viewModel = viewModel
                _ = vc.view
                
            }
            
            it("correctly binds viewModel to centerLabel") {
                expect(vc.centerLabel.text) == "Loading..."
                let expected = "expected"
                viewModel._centerLabelText.onNext(expected)
                expect(vc.centerLabel.text).toEventually(equal(expected))
            }
            
            it("correctly binds leftBuzzer to viewModel") {
                expect(viewModel.leftBuzzerTappedInTest) == false
                vc.leftBuzzer.sendActions(for: .touchUpInside)
                expect(viewModel.leftBuzzerTappedInTest) == true
            }
            
            it("correctly binds rightBuzzer to viewModel") {
                expect(viewModel.rightBuzzerTappedInTest) == false
                vc.rightBuzzer.sendActions(for: .touchUpInside)
                expect(viewModel.rightBuzzerTappedInTest) == true
            }
            
            it("correctly binds viewModel to leftScoreLabel") {
                expect(vc.leftScoreLabel.text) == "0"
                let expected = "1"
                viewModel._leftPlayerScore.onNext(expected)
                expect(vc.leftScoreLabel.text).toEventually(equal(expected))
            }
            
            it("correctly binds viewModel to rightScoreLabel") {
                expect(vc.rightScoreLabel.text) == "0"
                let expected = "1"
                viewModel._rightPlayerScore.onNext(expected)
                expect(vc.rightScoreLabel.text).toEventually(equal(expected))
            }
            
        }
        
    }
    
}
