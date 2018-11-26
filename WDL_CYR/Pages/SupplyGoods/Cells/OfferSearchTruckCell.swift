//
//  OfferSearchTruckCell.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/10/22.
//  Copyright © 2018年 yinli. All rights reserved.
//

import UIKit

class OfferSearchTruckCell: BaseCell {
    
    typealias CheckClosure = () -> ()
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var vichelNoLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var vichelLengthLabel: UILabel!
    @IBOutlet weak var vichelTypeLabel: UILabel!
    @IBOutlet weak var transportStatusLabel: UILabel!
    
    public var checkClosure:CheckClosure?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func checkHandle(_ sender: Any) {
        if let closure = self.checkClosure {
            closure()
        }
    }
    
}

extension OfferSearchTruckCell {
    
    func showInfo(vichelNo:String? , type:String? , length:String? ,weight:String? , check:Bool? = false , transporting:Bool? = false) -> Void {
        self.vichelNoLabel.text = vichelNo
        self.vichelTypeLabel.text = type
        self.vichelLengthLabel.text = length
        self.weightLabel.text = weight
        self.checkButton.isSelected = check ?? false
        self.checkButton.isUserInteractionEnabled = true
        if transporting == true {
            self.checkButton.isUserInteractionEnabled = false
        }
    }
}
