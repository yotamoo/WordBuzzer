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
        case .leading: return "Red player"
        case .trailing: return "Blue player"
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
    var centerLabelText: Driver<String?> { get }
    var leftPlayerScore: Driver<String?> { get }
    var rightPlayerScore: Driver<String?> { get }
    var showAlert: Driver<UIAlertController> { get }
    
}

class ViewModel: ViewModeling {
    
    private let bag = DisposeBag()
    
    private let _viewWillAppear = PublishSubject<Void>()
    private let leadingBuzzer = PublishSubject<Void>()
    private let trailingBuzzer = PublishSubject<Void>()
    
    private let _startAnimating = PublishSubject<Word>()
    private let _centerLabelText = PublishSubject<String?>()
    private let _leftPlayerScore = BehaviorSubject<Int>(value: 0)
    private let _rightPlayerScore = BehaviorSubject<Int>(value: 0)
    private let _showAlert = PublishSubject<UIAlertController>()
    
    // input
    let viewWillAppear: AnyObserver<Void>
    let leftBuzzerTapped: AnyObserver<Void>
    let rightBuzzerTapped: AnyObserver<Void>
    
    // output
    let startAnimating: Observable<Word>
    let centerLabelText: Driver<String?>
    let leftPlayerScore: Driver<String?>
    let rightPlayerScore: Driver<String?>
    let showAlert: Driver<UIAlertController>
    
    init(wordService: WordServicing, textService: ViewModelTexts) {
        
        self.viewWillAppear = self._viewWillAppear.asObserver()
        self.leftBuzzerTapped = leadingBuzzer.asObserver()
        self.rightBuzzerTapped = trailingBuzzer.asObserver()
        
        self.leftPlayerScore = self._leftPlayerScore
            .asObservable()
            .map { String($0) }
            .asDriver(onErrorJustReturn: nil)
        
        self.rightPlayerScore = self._rightPlayerScore
            .asObservable()
            .map { String($0) }
            .asDriver(onErrorJustReturn: nil)
        
        self.showAlert = self._showAlert.asDriver(onErrorDriveWith: Driver.never())
        self.startAnimating = self._startAnimating.asObservable()
        self.centerLabelText = self._centerLabelText.asDriver(onErrorJustReturn: nil)
        
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
            .withLatestFrom(_leftPlayerScore)
            .map { $0 + 1 }
            .startWith(0)
            .bind(to: _leftPlayerScore)
            .disposed(by: bag)
        
        rightWins
            .withLatestFrom(_rightPlayerScore)
            .map { $0 + 1 }
            .startWith(0)
            .bind(to: _rightPlayerScore)
            .disposed(by: bag)
        
        let anyWins = Observable.merge([leftWins, rightWins])
        
        anyWins
            .map { _ in false }
            .bind(to: inRoundSubject)
            .disposed(by: bag)
        
        let controllerTapped = PublishSubject<Void>()
        anyWins
            .map { (winner: Player) -> UIAlertController in
                let message = textService.alertMessage(withName: winner.description)
                let alert = UIAlertController(title: textService.alertTitle,
                                              message: message,
                    preferredStyle: .alert)
                
                let action = UIAlertAction(title: textService.alertButton,
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
            .map { $0.random }
            .filterNil()
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
