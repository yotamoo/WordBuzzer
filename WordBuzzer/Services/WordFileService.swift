//
//  WordFileService.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WordServicing {
    var words: Observable<[Word]?> { get }
}

class WordFileService: WordServicing {
    
    let words: Observable<[Word]?>
    private let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    init(fileName: String, bundle: Bundle) {
        
        self.words = bundle.rx.json(fromFile: fileName)
            .map { $0 as? [[String: String]] }
            .map { json in
                guard let json = json else {
                    return nil
                }
                return json
                    .flatMap { ($0["text_eng"], $0["text_spa"]) }
                    .flatMap { Word.init(english: $0.0, spanish: $0.1) }
            }
            .subscribeOn(globalScheduler) // will execnute on global thread by default
            .share(replay: 1, scope: .forever)
        
    }
    
}

private extension Reactive where Base: Bundle {
    
    func json(fromFile fileName: String) -> Observable<Any?> {
        
        return Observable<Any?>.create { observer in
            
            do {
                guard let url = self.base.url(forResource: fileName, withExtension: "json") else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return Disposables.create()
                }
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                observer.onNext(json)
                observer.onCompleted()
            }
            catch {
                // report to server
                observer.onNext(nil)
            }
            
            return Disposables.create()
            
        }
        
    }
    
}
