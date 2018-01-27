//
//  ViewController.swift
//  WordBuzzer
//
//  Created by Yotam Ohayon on 27/01/2018.
//  Copyright © 2018 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var leftBuzzer: UIButton!
    @IBOutlet weak var rightBuzzer: UIButton!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    var viewModel: ViewModeling!
    var wordLabel: UILabel?
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        let wordService = WordFileService(fileName: "words", bundle: bundle)
        let textService = TextService()
        self.viewModel = ViewModel(wordService: wordService,
                                   textService: textService)
        
        viewModel
            .centerLabelText
            .drive(self.centerLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .startAnimating
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.addWord($0)
            })
            .disposed(by: bag)
        
        leftBuzzer
            .rx
            .tap
            .bind(to: viewModel.leftBuzzerTapped)
            .disposed(by: bag)
        
        rightBuzzer
            .rx
            .tap
            .bind(to: viewModel.rightBuzzerTapped)
            .disposed(by: bag)
        
        viewModel
            .leftPlayerScore
            .drive(self.leftScoreLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .rightPlayerScore
            .drive(self.rightScoreLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .showAlert
            .drive(onNext: { [weak self] _ in
                self?.wordLabel?.removeFromSuperview()
            })
            .disposed(by: bag)
        
        viewModel
            .showAlert
            .map { ($0, false) }
            .drive(self.rx.present)
            .disposed(by: bag)
        
        self.rx
            .viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: bag)
        
    }
    
}

extension Reactive where Base: UIViewController {
    
    var present: Binder<(UIViewController, Bool)> {
        return Binder(self.base) { vc, data in
            let (destination, animated) = data
            vc.present(destination, animated: animated, completion: nil)
        }
    }
    
    var viewWillAppear: Observable<Void> {
        return self.base
            .rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }
    }
    
}

private extension ViewController {
    
    func addWord(_ word: Word) {
        
        print("adding word \(word)")
        self.wordLabel?.removeFromSuperview()
        let label = UILabel()
        label.text = word.spanish
        label.font = label.font.withSize(34)
        label.sizeToFit()
        label.layer.anchorPoint.x = 0
        label.center = CGPoint(x: -label.frame.width,
                               y: self.centerLabel.frame.midY / 2)
        self.view.addSubview(label)
        self.wordLabel = label
        
        UIView.animate(withDuration: 4) {
            label.center = CGPoint(x: self.view.bounds.maxX,
                                   y: self.centerLabel.frame.midY / 2)
        }
        
    }
    
}


