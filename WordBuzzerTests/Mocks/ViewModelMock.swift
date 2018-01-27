//
//  ViewModelMock.swift
//  WordBuzzerTests
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import WordBuzzer

class ViewModelMock: ViewModeling {
    
    //input
    let _viewWillAppear = PublishSubject<Void>()
    let viewWillAppear: AnyObserver<Void>
    let _leftBuzzerTapped = PublishSubject<Void>()
    let leftBuzzerTapped: AnyObserver<Void>
    let _rightBuzzerTapped = PublishSubject<Void>()
    let rightBuzzerTapped: AnyObserver<Void>
    
    // output
    let _startAnimating = PublishSubject<Word>()
    let startAnimating: Observable<Word>
    let _centerLabelText = PublishSubject<String?>()
    let centerLabelText: Driver<String?>
    let _leftPlayerScore = PublishSubject<String?>()
    let leftPlayerScore: Driver<String?>
    let _rightPlayerScore = PublishSubject<String?>()
    let rightPlayerScore: Driver<String?>
    let _showAlert = PublishSubject<UIAlertController>()
    let showAlert: Driver<UIAlertController>
    
    init() {
        self.viewWillAppear = self._viewWillAppear.asObserver()
        self.leftBuzzerTapped = self._leftBuzzerTapped.asObserver()
        self.rightBuzzerTapped = self._rightBuzzerTapped.asObserver()
        self.startAnimating = self._startAnimating
            .asObservable()
        self.centerLabelText = self._centerLabelText
            .asDriver(onErrorDriveWith: Driver.never())
        self.leftPlayerScore = self._leftPlayerScore
            .asDriver(onErrorDriveWith: Driver.never())
        self.rightPlayerScore = self._rightPlayerScore
            .asDriver(onErrorDriveWith: Driver.never())
        self.showAlert = self._showAlert
            .asDriver(onErrorDriveWith: Driver.never())
    }
    
}
