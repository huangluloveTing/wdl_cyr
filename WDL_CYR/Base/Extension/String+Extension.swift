//
//  String+Extension.swift
//  WDL_TYR
//
//  Created by 黄露 on 2018/9/11.
//  Copyright © 2018年 yingli. All rights reserved.
//

import Foundation

extension String {
    //MARK:-返回string的长度
    var length:Int{
        get {
            return self.count;
        }
    }
    
    //MARK: 拼接字符串
    func concat(one:String? , hiera:String? = "") -> String {
        let st = self + (one ?? "") + (hiera ?? "")
        return st
    }
    
    //MARK:-截取字符串从开始到 index
    func substring(to index: Int) -> String {
        guard let end_Index = validEndIndex(original: index) else {
            return self;
        }
        return String(self[startIndex..<end_Index]);
    }
    
    //MARK:-截取字符串从index到结束
    func substring(from index: Int) -> String {
        guard let start_index = validStartIndex(original: index)  else {
            return self
        }
        return String(self[start_index..<endIndex])
    }
    
    //MARK:-切割字符串(区间范围 前闭后开)
    func sliceString(_ range:CountableRange<Int>)->String{
        
        guard
            let startIndex = validStartIndex(original: range.lowerBound),
            let endIndex   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        return String(self[startIndex..<endIndex])
    }
    
    //MARK:-切割字符串(区间范围 前闭后闭)
    func sliceString(_ range:CountableClosedRange<Int>)->String{
        
        guard
            let start_Index = validStartIndex(original: range.lowerBound),
            let end_Index   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        if(endIndex.encodedOffset <= end_Index.encodedOffset){
            return String(self[start_Index..<endIndex])
        }
        return String(self[start_Index...end_Index])
        
    }
    
    //MARK:-校验字符串位置 是否合理，并返回String.Index
    private func validIndex(original: Int) -> String.Index {
        
        switch original {
        case ...startIndex.encodedOffset : return startIndex
        case endIndex.encodedOffset...   : return endIndex
        default                          : return index(startIndex, offsetBy: original)
        }
    }
    
    //MARK:-校验是否是合法的起始位置
    private func validStartIndex(original: Int) -> String.Index? {
        guard original <= endIndex.encodedOffset else { return nil }
        return validIndex(original:original)
    }
    
    //MARK:-校验是否是合法的结束位置
    private func validEndIndex(original: Int) -> String.Index? {
        guard original >= startIndex.encodedOffset else { return nil }
        return validIndex(original:original)
    }
    
    //MARK: - 验证字符串是否是 长度不为 0 或者 不为 nil
}
