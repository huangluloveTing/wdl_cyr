//
//  WayBillOneCommentCell.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/18.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillOneCommentCell: BaseCell {

    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var serviceRateView: UIView!
    
    private var scoreView:XHStarRateView?
    private var scoreServiceView:XHStarRateView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scoreView = XHStarRateView(frame: self.rateView.bounds)
        self.scoreView?.onlyShow = true
        self.rateView.addSubview(self.scoreView!)
        
        self.scoreServiceView = XHStarRateView(frame: self.serviceRateView.bounds)
        self.scoreServiceView?.onlyShow = true
        self.serviceRateView.addSubview(self.scoreServiceView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension WayBillOneCommentCell {
    
    func showComment(info:WayBillDetailCommentInfo?) -> Void {
        self.commentTimeLabel.text = Util.dateFormatter(date: (info?.commentTime ?? 0) / 1000, formatter: "yyyy-MM-dd HH:mm")
        self.commentLabel.text = info?.comment
        self.scoreView?.score = CGFloat(info?.logic ?? 0)
        self.scoreServiceView?.score = CGFloat(info?.service ?? 0)
    }
}
