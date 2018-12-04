//
//  MessageDetailAcceptCell.swift
//  WDL_CYR
//
//  Created by Apple on 2018/12/3.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class MessageDetailAcceptCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var detailInfoLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!//接受
    @IBOutlet weak var refuseBtn: UIButton!//拒绝
    
   
    // 声明一个闭包(有两个整形参数，且返回值为整形的闭包)
    typealias ButtonClosure = (_ sender: UIButton) ->()
    public var buttonClosure : ButtonClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.acceptBtn.addBorder(color: nil, radius: 15)
        self.refuseBtn.addBorder(color: nil, radius: 15)
    }
    //MARK:按钮
    @IBAction func buttonClick(_ sender: UIButton) {
      
        if let closure = self.buttonClosure {
            closure(sender)
        }

        
    }
  
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MessageDetailAcceptCell {
    func showDetalMessageInfo(title:String, content:String?, time: TimeInterval?) -> Void {
        self.titleLab.text = title
        self.detailInfoLab.text = content ?? " "
        self.dateLab.text = Util.dateFormatter(date: (time ?? 0 ) / 1000, formatter: "yyyy-MM-dd HH:mm")
       
    }
}



