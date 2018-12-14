//
//  Util.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/8/23.
//  Copyright © 2018年 yingli. All rights reserved.
//

import UIKit

class Util {
    
    static func showMoney(money:CGFloat , after point:Int = 2) -> String {
        let newMony = String(format: "%.\(point)f", money)
        return newMony
    }
    
    
    // 隐藏电话号码
    static func formatterPhone(phone:String) -> String {
        let count = phone.count
        if count != 11 {
            return phone
        }
        let newPhone = phone.prefix(3).appending("****").appending(phone.suffix(4))
        return newPhone
    }
    
    static func isPhoneNum(num:String?) -> Bool {
        let mobile = "^1(3[0-9]|5[0-9]|5[0-9]|7[0-9]|8[025-9]|9[0-9])\\d{8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if (regextestmobile.evaluate(with: num) == true){
            return true
        } else {
            return false
        }
    }
    
    
    static func toCallPhone(num:String?) {
        guard let phone = num else {
            print("电话号码不存在")
            return
        }
        let newPhone = phone.replacingOccurrences(of: " ", with: "")
        let url = URL(string:  "telprompt:" + newPhone)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }

    
    static func dateFormatter(date:TimeInterval,formatter:String = "yyyy-MM-dd") -> String {
        let toDate = Date(timeIntervalSince1970: date)
        return self.dateFormatter(date: toDate, formatter: formatter)
    }
    
    static func dateFormatter(date:Date , formatter:String = "yyyy-MM-dd") -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formatter
        return dateFormater.string(from: date)
    }
    
    static func timeIntervalFromDateStr(date:String , formatter:String = "yyyy-MM-dd") -> TimeInterval {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = formatter
        let dateTime = dateFomatter.date(from: date)
        return (dateTime?.timeIntervalSince1970 ?? 0) * 1000
    }
    
    static func configServerRegions(regions:[RegionModel]) -> [PlaceChooiceItem] {
        var items:[PlaceChooiceItem] = []
        for model_1 in regions {
            var item_1 = PlaceChooiceItem(title: model_1.label ?? "", id: model_1.value ?? "", selected: false, subItems: nil, level: 0)
            if let children = model_1.children {
                let sub_items_1 = self.configServerRegions(regions: children)
                item_1.subItems = sub_items_1
            }
            items.append(item_1)
        }
        return items
    }
    
    static func isEmptyString(str:String?) -> Bool {
        guard let newStr = str else {
            return true
        }
        if newStr.count == 0 {
            return true
        }
        return false
    }
    
    // 保留浮点数的小数点位数
    static func floatPoint(num:Int , floatValue:Float) -> String {
        return String(format: "%.\(num)f", floatValue)
    }
    
    // 富文本，行间距和字体大小
    static func sepecialText(text:String? = "" , lineSpace:Float , font:UIFont , color:UIColor) -> NSAttributedString {
        let targetValue = text ?? ""
        let attribute = NSMutableAttributedString(string: targetValue)
        attribute.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: targetValue.length > 0 ? targetValue.length - 1 : 0))
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = CGFloat(lineSpace)
        attribute.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: NSRange(location: 0, length: targetValue.length > 0 ? targetValue.length - 1 : 0))
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSRange(location: 0, length: targetValue.length > 0 ? targetValue.length - 1 : 0))
        return attribute
    }
    
    static func contact(strs:[String] , seperate:String = "") -> String {
        var newStr = ""
        strs.enumerated().forEach { (offset , st) in
            if offset < strs.count - 1 {
                if st.count > 0 {
                    newStr = newStr + st + seperate
                }
            } else {
                newStr = newStr + st
            }
        }
        return newStr
    }
    
    static func concatSeperateStr(seperete:String? = " | " , strs:String? ...) -> String {
        var valueStr = ""
        strs.enumerated().forEach { (index ,st) in
            if let st = st {
                if st.count > 0 {
                    if index != (strs.count - 1) {
                        valueStr = valueStr + st + (seperete ?? "")
                    } else {
                        valueStr = valueStr + st
                    }
                }
            }
        }
        return valueStr
    }
    
    static func showImage(imageView:UIImageView , imageUrl:String? , placeholder:UIImage = #imageLiteral(resourceName: "avator")) {
        var newImageUrl = imageUrl
        newImageUrl = newImageUrl?.replacingOccurrences(of: "\n", with: "")
        newImageUrl = newImageUrl?.trimmingCharacters(in: CharacterSet.whitespaces)
        let imageResource = URL.init(string: newImageUrl ?? "")
        imageView.kf.setImage(with: imageResource, placeholder: placeholder)
    }
    
    static func isSimulator() -> Bool{
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    
}

// 富文本 YYText
extension Util {

}
