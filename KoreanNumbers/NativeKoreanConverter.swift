//
//  NativeKoreanConverter.swift
//  KoreanNumbers
//
//  Created by Kangiriyanka The Single Leaf on 2025/06/14.
//

import Foundation


struct NativeKoreanConverter {
    
    
    
    var nativeKoreanNumber: String
    
    let ones = ["", "하나", "둘", "셋", "넷", "다섯", "여섯", "일곱", "여덟", "아홉"]
    let tens = ["", "열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
    
    //    Get the length of our number
    func getNumberLength() -> Int {
        return nativeKoreanNumber.count
    }
    
    func convertNumber() -> String {
        
        var convertedNumber = ""
        let length = getNumberLength()
        
        
        if length < 2  {
            
            if let index = Int(nativeKoreanNumber) {
                convertedNumber = (index == 0) ? "공" : ones[index]
            }
        } else {
            
            if let firstDigit = Int(nativeKoreanNumber.prefix(1)), let secondDigit = Int(nativeKoreanNumber.suffix(1)) {
                
                convertedNumber += tens[firstDigit] + ones[secondDigit]
            }
        }
        
        return convertedNumber
        
        
    }
}
