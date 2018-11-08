//
//  WaybillChangeLoadTimeView.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/11/7.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WaybillChangeLoadTimeView: UIView {
    
    typealias WaybillChangeLoadTimeClosure = (TimeInterval?) -> ()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadTimeTextField: UITextField!
    @IBOutlet weak var transportNoLabel: UILabel!
    @IBOutlet weak var commitButton: UIButton!
    
    private var currentTime:TimeInterval?
    private var transportNo:String?
    
    var closure:WaybillChangeLoadTimeClosure?
    
    let dispose = DisposeBag()
    static func instance() -> WaybillChangeLoadTimeView? {
        let view = self.loadBindView(viewName: WaybillChangeLoadTimeView.self)
        view?.configAllViews()
        return view
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let nPoint = self.convert(point, to: self.contentView)
        if self.contentView.point(inside: nPoint, with: event) == false {
            self.hiddenAndRemove()
        }
        return super.hitTest(point, with: event)
    }
}

extension WaybillChangeLoadTimeView {
    
    func show(transportNo:String) -> Void {
        self.loadTimeTextField.text = ""
        self.currentTime = nil
        self.transportNoLabel.text = transportNo
        self.loadTimeTextField.becomeFirstResponder()
        let window = UIApplication.shared.keyWindow
        self.frame = window?.bounds ?? CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: IPHONE_HEIGHT)
        window?.addSubview(self)
        self.contentView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = CGAffineTransform.identity
        }
    }
    
    func hiddenAndRemove() -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        })
        self.removeFromSuperview()
    }
}

//MARK: - config
extension WaybillChangeLoadTimeView {
    
    func configAllViews() -> Void {
        self.backgroundColor = UIColor(hex: "000000").withAlphaComponent(0.4)
        self.isUserInteractionEnabled = true
        self.contentView.addBorder(color: nil, width: 0, radius: 5)
        self.commitButton.addBorder(color: nil, width: 0, radius: 5)
        self.loadTimeTextField.inputView = self.textInputView()
        self.commitButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                if let closure = self?.closure {
                    closure(self?.currentTime)
                }
            })
            .disposed(by: dispose)
    }
    
    func textInputView() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.rx.date.asObservable()
            .distinctUntilChanged()
            .skip(1)
            .map({ [weak self](date) -> String in
                self?.currentTime = date.timeIntervalSince1970
                return Util.dateFormatter(date: date, formatter: "yyyy-MM-dd")
            })
            .bind(to: self.loadTimeTextField.rx.text)
            .disposed(by: dispose)
        
        return datePicker
    }
    
}
