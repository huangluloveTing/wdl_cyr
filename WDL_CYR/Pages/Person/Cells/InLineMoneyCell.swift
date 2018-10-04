//
//  InLineMoneyCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/4.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let OptionalChargeMoneys = [1000 , 2000 , 3000 , 4000 , 5000 , 6000 , 7000 , 8000, 9000]

class InLineMoneyCell: BaseCell {
    
    private let dispose = DisposeBag()
    private var opitionIndex:Int = 0
    private var inputRechargeMoney:Float? = 0
    
    typealias InLineReChargeClosure = (_ select:Float , _ input:Float?) -> ()
    
    @IBOutlet weak var optionalView: ZTTagView!
    @IBOutlet weak var inputChargeNumTextField: UITextField!
    @IBOutlet weak var sureChargeButton: UIButton!
    
    public var rechargeClosure:InLineReChargeClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sureChargeButton.addBorder(color: nil, width: 0, radius: 4)
        self.configTagView(tagView: self.optionalView)
        self.optionalView.preference_maxWidth = IPHONE_WIDTH
        self.optionalView.showTags(self.getTagOptionals())
        self.initailAndBind()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initailAndBind() -> Void {
        self.inputChargeNumTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self](text) in
                self?.inputRechargeMoney = Float(text)
            })
            .disposed(by: dispose)
        self.sureChargeButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.sureTapAction()
            })
            .disposed(by: dispose)
    }
    
    func sureTapAction() -> Void {
        if let closure = self.rechargeClosure  {
            closure(Float(OptionalChargeMoneys[self.opitionIndex]) , self.inputRechargeMoney)
        }
    }
}

extension InLineMoneyCell {
    func getTagOptionals(index:Int = 0) -> [ZTTagItem] {
        let tags = OptionalChargeMoneys.enumerated().map { (eIndex, money) -> ZTTagItem in
            let text = String(format: "%d元", money)
            let item = ZTTagItem()
            item.isCheck = false
            if eIndex == index {
                item.isCheck = true
            }
            item.title = text
            return item
        }
        return tags
    }
}

extension InLineMoneyCell {
    
    override func tagViewMarginForTagView() -> CGFloat {
        return 20
    }
    
    func tagView(_ tagView: ZTTagView!, didTap index: Int) {
        tagView.showTags(self.getTagOptionals(index: index))
        self.opitionIndex = index
    }
    
    override func tagView(_ tagView: ZTTagView!, backgroundColorFor state: UIControlState, at index: Int) -> UIColor! {
        if state == .normal {
            return UIColor.white
        }
        return UIColor(hex: "DCF6E8")
    }
    
    override func perCount(for tagView: ZTTagView!) -> Int {
        return 3
    }
    
    func broaderWidth(for tagView: ZTTagView!) -> CGFloat {
        return 1
    }
    
    func broaderColor(for tagView: ZTTagView!, at index: Int) -> UIColor! {
        return UIColor(hex: "DDDDDD")
    }
    
    override func cornerRadius(for tagView: ZTTagView!) -> CGFloat {
        return 2
    }
    
    override func itemHeight(for tagView: ZTTagView!) -> CGFloat {
        return 50
    }
    
    override func tagView(_ tagView: ZTTagView!, titleColorFor state: UIControlState) -> UIColor! {
        if state == .normal {
            return UIColor(hex: TEXTFIELD_TEXTCOLOR)
        }
        return UIColor(hex: COLOR_BUTTON)
    }
    
    override func textFont(for tagView: ZTTagView!) -> UIFont! {
        return UIFont.systemFont(ofSize: 16)
    }
}
