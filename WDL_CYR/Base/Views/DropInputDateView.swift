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
    
    typealias DropInputDateViewClosure = (TimeInterval? , TimeInterval? , Bool) -> ()
    
    @IBOutlet weak var endSeperateLine: UIView!
    @IBOutlet weak var startSeperateLine: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    private var startTime:TimeInterval?
    private var endTime:TimeInterval?
    
    public var dropInputClosure:DropInputDateViewClosure?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func sureHandle(_ sender: Any) {
        if let closure = self.dropInputClosure {
            closure(self.startTime , self.endTime , true)
        }
    }
    
    @IBAction func cancelHandle(_ sender: Any) {
        if let closure = self.dropInputClosure {
            closure(self.startTime , self.endTime , false)
        }
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
                self?.startIsFirstResponse()
            })
            .disposed(by: dispose)
        self.endTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self](text) in
                self?.endTime = Double(text) ?? 0
                self?.endIsFirstResponse()
            })
            .disposed(by: dispose)
    }
    
    func inputStartDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.rx.date.asObservable()
            .skip(1)
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
        datePicker.minimumDate = Date(timeIntervalSince1970: self.startTime ?? 0)
        datePicker.rx.date.asObservable()
            .skip(1)
            .map { (date) -> String in
                let dateString = Util.dateFormatter(date: date, formatter: "yyyy-MM-dd")
                return dateString
            }
            .bind(to: self.endTextField.rx.text)
            .disposed(by: dispose)
        return datePicker
    }
    
    // 当开始时间处于第一响应时
    func startIsFirstResponse() -> Void {
        self.startSeperateLine.backgroundColor = UIColor(hex: "06C06F")
        self.endSeperateLine.backgroundColor = UIColor(hex: "DDDDDD")
    }
    
    // 当结束时间处于第一响应时
    func endIsFirstResponse() -> Void {
        self.endSeperateLine.backgroundColor = UIColor(hex: "06C06F")
        self.startSeperateLine.backgroundColor = UIColor(hex: "DDDDDD")
    }
}

//MARK: - initial
extension DropInputDateView {
    
    static func instanceDateView() -> DropInputDateView {
        let dropView = loadBindView(viewName: self)!
        dropView.configSubViews()
        let size = dropView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        dropView.zt_width = IPHONE_WIDTH
        dropView.zt_height = size.height
        return dropView
    }
    
}
