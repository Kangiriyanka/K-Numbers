//
//  SinoKorean.swift
//  KoreanNumbers
//


struct SinoKoreanConverter {
    
   
    var sinoKoreanNumber: String
    
    var answerString: String = ""
    let ones = ["", "일","이", "삼", "사", "오", "육", "칠", "팔", "구"]
    let placeValues = ["", "십","백","천","만","억","조"]
    
    
    //    Get the length of our number
    func getNumberLength() -> Int {
        return sinoKoreanNumber.count
    }
    
    //    Get all the place values matching the length of the number
    //    If our number has 3 digits, it returns ["백", "십", ""]
    
    //    Returns all the unit names , if we have 123, it returns the array ["일", "이", "삼"]
    func getDigitNames() -> [String] {
        var digitNames : [String] = []
        //      digit is of type Char
        //      The method wholeNumberValue on Char returns an optional Int
        for digit in sinoKoreanNumber {
            
            if let digitValue = digit.wholeNumberValue {
                digitNames.append(ones[digitValue])
                
                
            }
            
        }
        //        Reverse to start from the unit position
        
        return digitNames.reversed()
    }
    
    
    func convertNumber() -> String {
        
        
        var convertedNumber = ""
        var groupIndex = 0
        let length = getNumberLength()
        let digitNames = getDigitNames()
        
        
        // If nothing is in the TextField, return 0 and if it's only a digit, return its name
        if length < 2  {
            
            convertedNumber = digitNames[0] == "" ? "영" : digitNames[0]
        } else {
            
            for index in 0 ..< length {
                //                Excluding the first digit, check for subsequent higher place values such as 만,억,조
                
                // We can add an extra exception for 1 e.g. 일만 becomes 만, but for simplicity, it's been omitted
                if index % 4 == 0 && index > 0 {
                    
                    convertedNumber +=
                    
                    " " + placeValues[4 + groupIndex] + digitNames[index]
                    
                    groupIndex += 1
                }
                
                
                else {
                    //Different logic for 1, no need for the digit name
                    if index > 0 && digitNames[index] == "일" {
                        convertedNumber += placeValues[ index % 4 ]
                    }
                    else {
                        //Check for 0
                        convertedNumber += (digitNames[index] != "") ?   placeValues[index % 4 ] +  digitNames[index] : ""
                        
                        
                    }
                    
                }
                
            }
            
        }
        return String(convertedNumber.reversed())
    }
    
    
  
}
