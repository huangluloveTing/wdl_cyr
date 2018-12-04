//
//  MessageDetailCell.swift
//  WDL_TYR
//
//  Created by Apple on 2018/11/21.
//  Copyright © 2018 yinli. All rights reserved.
//

import UIKit

class MessageDetailCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var detailInfoLab: UILabel!
    
    @IBOutlet weak var dateLab: UILabel!
  
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension MessageDetailCell {
    func showDetalMessageInfo(title:String, content:String?, time: TimeInterval?) -> Void {
        self.titleLab.text = title
        self.detailInfoLab.text = content ?? " "
        self.dateLab.text = Util.dateFormatter(date: (time ?? 0 ) / 1000, formatter: "yyyy-MM-dd HH:mm")
       
    }
}
