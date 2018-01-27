//
//  WordFileService.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation

protocol WordServicing {
    var words: [Word]? { get }
}

class WordFileService: WordServicing {
    
    let words: [Word]?
    
    init(fileName: String, bundle: Bundle) {
        
        // i pass bundle because to make it testable
        guard let json = json(formBundle: bundle, fileName: fileName),
            let rawWords = json as? [[String: String]] else {
                self.words = nil
                return
        }
        
        self.words = rawWords
            .flatMap { ($0["text_eng"], $0["text_spa"]) }
            .flatMap { Word.init(english: $0.0, spanish: $0.1) }
        
    }
    
}

private func json(formBundle bundle: Bundle = Bundle.main, fileName: String) -> Any? {
    
    do {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        return try JSONSerialization.jsonObject(with: data,
                                                options: .allowFragments)
    }
    catch {
        // report to server
        return nil
    }
    
}
