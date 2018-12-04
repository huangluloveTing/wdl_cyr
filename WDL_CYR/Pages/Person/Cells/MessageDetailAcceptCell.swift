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
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
   
    //货源或运单id
    var hallId: String?
    
    // 声明一个闭包(有两个整形参数，且返回值为整形的闭包)
    typealias ButtonClosure = (_ sender: UIButton, _ hallId: String) ->()
    public var buttonClosure : ButtonClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK:按钮
    @IBAction func buttonClick(_ sender: UIButton) {
        if sender.tag == 44 {
            //拒绝
        }else {
            //接受
        }
        
        
//        if let closure = self.buttonClosure {
//            closure(sender, self.hallId ?? "")
//        }
//
        
    }
  
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MessageDetailAcceptCell {
    func showDetalMessageInfo(title:String, content:String?, time: TimeInterval?, buttonTitle: String, hallId: String) -> Void {
        self.titleLab.text = title
        self.detailInfoLab.text = content ?? " "
        self.dateLab.text = Util.dateFormatter(date: (time ?? 0 ) / 1000, formatter: "yyyy-MM-dd HH:mm")
        
        self.hallId = hallId
    }
}