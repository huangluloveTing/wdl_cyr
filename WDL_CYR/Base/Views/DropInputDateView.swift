//
//  DropInputDateView.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/26.
//  Copyright © 2018 yinli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DropInputDateView : UIView {
    
    private let dispose = DisposeBag()
    
    typealias DropInputDateViewClosure = (TimeInterval? , TimeInterval?) -> ()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    private var startTime:TimeInterval?
    private var endTime:TimeInterval?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func sureHandle(_ sender: Any) {
        
    }
    
    @IBAction func cancelHandle(_ sender: Any) {
        
    }
}


//MARK: - 配置view
extension DropInputDateView {
    func configSubViews() -> Void {
        self.bottomView.shadow(color: UIColor(hex: "BBBBBB"), offset: CGSize(width: 0, height: -2), opacity: 0.4, radius: 2)
        self.startTextField.inputView = self.inputStartDatePicker()
        self.endTextField.inputView = self.inputEndDatePicker()
        self.startTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.startTime = Double(text) ?? 0
            })
            .disposed(by: dispose)
        self.endTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.endTime = Double(text) ?? 0
            })
            .disposed(by: dispose)
    }
    
    func inputStartDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.rx.date.asObservable()
            .map { (date) -> String in
                let dateString = Util.dateFormatter(date: date, formatter: "yyyy-MM-dd")
                return dateString
            }
            .bind(to: self.startTextField.rx.text)
            .disposed(by: dispose)
        return datePicker
    }
    
    func inputEndDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.rx.date.asObservable()
            .map { (date) -> String in
                let dateString = Util.dateFormatter(date: date, formatter: "yyyy-MM-dd")
                return dateString
            }
            .bind(to: self.endTextField.rx.text)
            .disposed(by: dispose)
        return datePicker
    }
}

//MARK: - initial
extension DropInputDateView {
    
    static func instanceDateView() -> DropInputDateView {
        let dropView = loadBindView(viewName: self)!
        dropView.configSubViews()
        return dropView
    }
    
}
