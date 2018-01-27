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
//                let window = UIWindow(frame: UIScreen.main.bounds)
//                window.makeKeyAndVisible()
//                window.rootViewController = vc
                
            }
            
            it("centerLabel") {
                expect(vc.centerLabel.text) == "Loading..."
                let expected = "expected"
                viewModel.centerLabelText.drive(onNext: {
                    print($0)
                })
                viewModel._centerLabelText.onNext(expected)
                expect(vc.centerLabel.text).toEventually(equal(expected))
            }
            
        }
        
    }
    
}
