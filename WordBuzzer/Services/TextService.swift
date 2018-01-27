//
//  TextService.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation

protocol ViewModelTexts {
    var alertTitle: String { get }
    func alertMessage(withName: String) -> String
    var alertButton: String { get }
}

struct TextService {}

extension TextService: ViewModelTexts {
    var alertTitle: String {
        return "Correct!"
    }
    func alertMessage(withName name: String) -> String {
        return "\(name) wins"
    }
    var alertButton: String {
        return "Continue"
    }
}
