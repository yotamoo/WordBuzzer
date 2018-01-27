//
//  ViewModel.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

enum Player: CustomStringConvertible {
    case leading, trailing
    var description: String {
        switch self {
        case .leading: return "leading"
        case .trailing: return "trailing"
        }
    }
}

protocol ViewModeling {
    
    //input
    var viewWillAppear: AnyObserver<Void> { get }
    var leftBuzzerTapped: AnyObserver<Void> { get }
    var rightBuzzerTapped: AnyObserver<Void> { get }
    
    // output
    var startAnimating: Observable<Word> { get }
    var centerLabelText: Driver<String> { get }
    var leftPlayerScore: Observable<String> { get }
    var rightPlayerScore: Observable<String> { get }
    var showAlert: Observable<UIAlertController> { get }
    
}

class ViewModel: ViewModeling {
    
    private let bag = DisposeBag()
    private let leadingScore = BehaviorSubject<Int>(value: 0)
    private let trailingScore = BehaviorSubject<Int>(value: 0)
    private let leadingBuzzer = PublishSubject<Void>()
    private let trailingBuzzer = PublishSubject<Void>()
    private let _showAlert = PublishSubject<UIAlertController>()
    private let _startAnimating = PublishSubject<Word>()
    private let _centerLabelText = PublishSubject<String>()
    private let _viewWillAppear = PublishSubject<Void>()
    
    // input
    let viewWillAppear: AnyObserver<Void>
    let leftBuzzerTapped: AnyObserver<Void>
    let rightBuzzerTapped: AnyObserver<Void>
    
    // output
    let startAnimating: Observable<Word>
    let centerLabelText: Driver<String>
    let leftPlayerScore: Observable<String>
    let rightPlayerScore: Observable<String>
    let showAlert: Observable<UIAlertController>
    
    init(wordService: WordServicing) {
        
        self.viewWillAppear = self._viewWillAppear.asObserver()
        self.leftBuzzerTapped = leadingBuzzer.asObserver()
        self.rightBuzzerTapped = trailingBuzzer.asObserver()
        self.leftPlayerScore = self.leadingScore.asObservable().map { String($0) }
        self.rightPlayerScore = self.trailingScore.asObservable().map { String($0) }
        self.showAlert = self._showAlert.asObservable()
        self.startAnimating = self._startAnimating.asObservable()
        self.centerLabelText = self._centerLabelText.asDriver(onErrorDriveWith: Driver.never())
        
        let words = wordService.words
        let wordsObservable = Observable.just(words)
        
        let englishSubject = PublishSubject<Word>()
        let english = englishSubject.asObservable()
        
        english
            .map {
                $0.english
            }
            .debug()
            .bind(to: self._centerLabelText)
            .disposed(by: bag)
        
        let inRoundSubject = PublishSubject<Bool>()
        let inRound = inRoundSubject.asObservable().startWith(true)
        
        let spanish = english
            .flatMapLatest { _ in wordObservable(forWords: words,
                                                 interval: 3,
                                                 whileCondition: inRound) }
            .share()
        
        spanish
            .bind(to: self._startAnimating)
            .disposed(by: bag)
        
        let buzzerTapped = PublishSubject<Player>()
        
        leadingBuzzer
            .map { Player.leading }
            .bind(to: buzzerTapped)
            .disposed(by: bag)
        
        trailingBuzzer
            .map { Player.trailing }
            .bind(to: buzzerTapped)
            .disposed(by: bag)
        
        let tapEvent = buzzerTapped
            .withLatestFrom(spanish) { ($0, $1) }
            .withLatestFrom(english) { ($0.0, $0.1, $1) }
        
        let win = tapEvent
            .filter { $0.1 == $0.2 }
            .map { $0.0 }
        
        let leftWins = win.filter { $0 == Player.leading }
        let rightWins = win.filter { $0 == Player.trailing }
        
        leftWins
            .withLatestFrom(leadingScore)
            .map { $0 + 1 }
            .bind(to: leadingScore)
            .disposed(by: bag)
        
        rightWins
            .withLatestFrom(trailingScore)
            .map { $0 + 1 }
            .bind(to: leadingScore)
            .disposed(by: bag)
        
        let anyWins = Observable.merge([leftWins, rightWins])
        
        anyWins
            .map { _ in false }
            .bind(to: inRoundSubject)
            .disposed(by: bag)
        
        let controllerTapped = PublishSubject<Void>()
        anyWins
            .map { (winner: Player) -> UIAlertController in
                let alert = UIAlertController(title: "Win!",
                                              message: "\(winner) wins!!!",
                    preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Continue",
                                           style: .default)
                { _ in
                    controllerTapped.onNext(())
                }
                
                alert.addAction(action)
                return alert
            }
            .bind(to: self._showAlert)
            .disposed(by: bag)
        
        controllerTapped
            .map { true }
            .bind(to: inRoundSubject)
            .disposed(by: bag)
        
        controllerTapped
            .withLatestFrom(wordsObservable)
            .filterNil()
            .map { $0.random }
            .filterNil()
            .bind(to: englishSubject)
            .disposed(by: bag)
        
        // kickoff
        self._viewWillAppear
            .asObservable()
            .withLatestFrom(wordsObservable)
            .filterNil()
            .map { $0[0] }
            .bind(to: englishSubject)
            .disposed(by: bag)
        
    }
    
}

private func wordObservable(forWords words: [Word]?,
                            interval: Double,
                            whileCondition: Observable<Bool>) -> Observable<Word> {
    
    guard let words = words else {
        return Observable.never()
    }
    
    return Observable<Int>
        .interval(interval, scheduler: MainScheduler.instance)
        .startWith(1)
        .map { words[$0 % words.count] }
        .withLatestFrom(whileCondition) { ($0, $1) }
        .filter { $0.1 }
        .map { $0.0 }
    
}
