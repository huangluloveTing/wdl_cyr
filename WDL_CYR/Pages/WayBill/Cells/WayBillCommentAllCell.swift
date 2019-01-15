//
//  WayBillCommentAllCell.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/18.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillCommentAllCell: BaseCell {
    
    @IBOutlet weak var toMeLogicRateView: UIView!
    @IBOutlet weak var toMeServiceRateView: UIView!
    
    @IBOutlet weak var myServiceRateView: UIView!
    @IBOutlet weak var myRateView: UIView!
    
    @IBOutlet weak var tomeCommentTimeLabel: UILabel!
    @IBOutlet weak var toMeCommentLabel: UILabel!
    @IBOutlet weak var toOtherCommentLabel: UILabel!
    @IBOutlet weak var myCommentTimeLabel: UILabel!
    
    private var toMeLogicStarView:XHStarRateView?
    private var toMeServiceStarView:XHStarRateView?
    private var myLogicCommentStarView:XHStarRateView?
    private var myServiceCommentStarView:XHStarRateView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.toMeLogicStarView = XHStarRateView(frame: self.toMeLogicRateView.bounds)
        self.toMeLogicStarView?.onlyShow = true
        self.toMeServiceStarView = XHStarRateView(frame: (self.toMeServiceRateView.bounds))
        self.toMeServiceStarView?.onlyShow = true
        self.toMeLogicRateView.addSubview(self.toMeLogicStarView!)
        self.toMeServiceRateView.addSubview(self.myServiceCommentStarView!)
        
        self.myLogicCommentStarView = XHStarRateView(frame: self.myRateView.bounds)
        self.myLogicCommentStarView?.onlyShow = true
        self.myServiceCommentStarView = XHStarRateView(frame: (self.myServiceRateView.bounds))
        self.myServiceCommentStarView?.onlyShow = true
        self.myRateView.addSubview(self.myLogicCommentStarView!)
        self.myServiceRateView.addSubview(self.myServiceCommentStarView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WayBillCommentAllCell {
    
    func showCommentInfo(toMeinfo:WayBillDetailCommentInfo?, myCommentInfo:WayBillDetailCommentInfo?) -> Void {
        self.toMeLogicStarView?.score = CGFloat(toMeinfo?.logic ?? 0)
        self.toMeServiceStarView?.score = CGFloat(toMeinfo?.service ?? 0)
        self.tomeCommentTimeLabel.text = Util.dateFormatter(date: (toMeinfo?.commentTime ?? 0.0) / 1000, formatter: "yyyy-MM-dd HH:mm");
        self.toMeCommentLabel.text = toMeinfo?.comment
        
        self.myLogicCommentStarView?.score = CGFloat(myCommentInfo?.logic ?? 0)
        self.myServiceCommentStarView?.score = CGFloat(myCommentInfo?.service ?? 0)
        self.myCommentTimeLabel.text = Util.dateFormatter(date: (myCommentInfo?.commentTime ?? 0.0) / 1000, formatter: "yyyy-MM-dd HH:mm");
        self.toOtherCommentLabel.text = myCommentInfo?.comment
    }
}
