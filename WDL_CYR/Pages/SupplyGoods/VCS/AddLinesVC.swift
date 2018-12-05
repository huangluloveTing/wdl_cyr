//
//  AddLinesVC.swift
//  WDL_CYR
//
//  Created by 黄露 on 2018/9/26.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit
import RxSwift

class AddLinesVC: NormalBaseVC {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var commitButton: UIButton!
    
    private var startCity:String?
    private var startProvince:String?
    private var endCity:String?
    private var endProvince:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: COLOR_BACKGROUND)
        self.commitButton.addBorder(color: nil, width: 0, radius: 4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func bindViewModel() {
        self.startTextField.titleTextField(title: "  始发地  ", indicator: true)
        self.endTextField.titleTextField(title: "  目的地  ", indicator: true)
        
        let items = self.initialPlace().share(replay: 1)
        items.map { (areas) -> PublishSubject<(PlaceChooiceItem?,PlaceChooiceItem?,PlaceChooiceItem?)> in
            return self.startTextField.placeInputView(items: areas)
            }
            .subscribe(onNext: { [weak self](input) in
                input.subscribe(onNext: { (arg0) in
                    let (province, city, _) = arg0
                    self?.startCity = city?.title
                    self?.startProvince = province?.title
                    self?.startTextField.text = (self?.startProvince ?? "") + (self?.startCity ?? "")
                })
                .disposed(by: (self?.dispose)!)
            })
            .disposed(by: dispose)
        items.map { (areas) -> PublishSubject<(PlaceChooiceItem?,PlaceChooiceItem?,PlaceChooiceItem?)> in
            return self.endTextField.placeInputView(items: areas)
            }
            .subscribe(onNext: { [weak self](input) in
                input.subscribe(onNext: { (arg0) in
                    let (province, city, _) = arg0
                    self?.endCity = city?.title
                    self?.endProvince = province?.title
                    self?.endTextField.text = (self?.endProvince ?? "") + (self?.endCity ?? "")
                })
                    .disposed(by: (self?.dispose)!)
            })
            .disposed(by: dispose)
        
        self.commitButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self]() in
                self?.toAddLine()
            })
            .disposed(by: dispose)
    }
    
    
    func toAddLine() -> Void {
        self.showLoading(title: "正在提交", canInterface: false)
        BaseApi.request(target: API.addFollowLine(self.startProvince ?? "", self.startCity ?? "", self.endProvince ?? "", self.endCity ?? ""), type: BaseResponseModel<String>.self)
            .retry(5)
            .subscribe(onNext: { [weak self](data) in
                self?.showSuccess(success: nil, complete: {
                    self?.pop()
                })
            }, onError: { [weak self](error) in
                self?.showLoading(title: error.localizedDescription, canInterface: false)
            })
            .disposed(by: dispose)
    }

}
