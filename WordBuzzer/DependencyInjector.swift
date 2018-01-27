//
//  DependencyInjector.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class DependencyInjector {
    
    private let container = Container()
    
    lazy var storyboard: SwinjectStoryboard = {
        return  SwinjectStoryboard.create(name: "Main",
                                          bundle: nil,
                                          container: self.container)
    }()
    
    init() {
        registerServices()
        registerScreens()
    }
    
}

private extension DependencyInjector {
    
    func registerServices() {
        
        container.register(Bundle.self) { _ in
            Bundle(for: type(of: self))
        }
        
        container.register(WordServicing.self) { r in
            WordFileService(fileName: "words",
                            bundle: r.resolve(Bundle.self)!)
        }
        
        container.register(TextService.self) { _ in
            TextService()
        }
        
    }
    
    func registerScreens() {
        
        container.register(ViewModeling.self) { r in
            ViewModel(wordService: r.resolve(WordServicing.self)!,
                      textService: r.resolve(TextService.self)!)
        }
        
        container.storyboardInitCompleted(ViewController.self) { r, c in
            c.viewModel = r.resolve(ViewModeling.self)
        }
        
    }
    
}
