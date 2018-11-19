//
//  WayBillReceiptCell.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/18.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class WayBillReceiptCell: BaseCell {
    
    typealias ReceiptTapClosure = (Int) -> ()

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var receiptList:[ZbnTransportReturn]?
    private var canEdit:Bool = false
    
    public var maxPic:Int = 3
    
    public var tapClosure:ReceiptTapClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WayBillReceiptCell {
    
    func configCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 135, height: self.collectionView.zt_height)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "\(WayBillReceiptItem.self)", bundle: nil), forCellWithReuseIdentifier: "\(WayBillReceiptItem.self)")
        collectionView.register(UINib.init(nibName: "\(WayBillReceiptEditItem.self)", bundle: nil), forCellWithReuseIdentifier: "\(WayBillReceiptEditItem.self)")
    }
}

extension WayBillReceiptCell : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.receiptList?.count ?? 0
        if count >= self.maxPic {
            return self.maxPic
        }
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = self.receiptList?.count ?? 0
        if indexPath.row == count {
            let editCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WayBillReceiptEditItem.self)", for: indexPath)
            return editCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WayBillReceiptItem.self)", for: indexPath) as! WayBillReceiptItem
        let receipt = self.receiptList![indexPath.row]
        cell.showReceipt(imageUrl: receipt.returnBillUrl, time: receipt.startTime)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = tapClosure {
            closure(indexPath.row)
        }
    }
}

extension WayBillReceiptCell {
    
    func showReceiptInfo(info:[ZbnTransportReturn] , canEdit:Bool = false) -> Void {
        self.receiptList = info
        self.canEdit = canEdit
        self.collectionView.reloadData()
    }
}
