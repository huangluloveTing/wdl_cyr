//
//  OfferDealTimerCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/28.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class OfferDealTimerCell: BaseCell {

    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    private var cuntDownTime : TimeInterval = 0
    
    private var timer : Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @objc func timerHandler() -> Void {
        if self.cuntDownTime == 0 {
            self.timerDisplay(hours: 0, minus: 0, second: 0)
            return
        }
        let second = self.cuntDownTime / 1000
        let hours = floor(second / Double(3600))
        let minus = floor((second - hours * 3600) / 60)
        let seconds = second - (hours * 3600 + minus * 60)
        self.timerDisplay(hours: hours, minus: minus, second: seconds)
    }
    
    // 设置 倒计时时间
    func timerDisplay(hours:Double , minus:Double , second:Double) -> Void {
        self.hourLabel.text = String(format: "%.f", hours)
        self.minuteLabel.text = String(format: "%.f", minus)
        self.secondLabel.text = String(format: "%.f", second)
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension OfferDealTimerCell {
    
    func showCuntDownTime(time:TimeInterval) -> Void {
        self.cuntDownTime = time
    }
}
