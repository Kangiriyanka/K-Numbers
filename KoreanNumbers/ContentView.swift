//
//  ContentView.swift
//  KoreanNumbers
//
//  Created by kangiriyanka on 2024/01/02.

// GOAL: Application that teaches how to say a number in Korean. The answer can be in either Native or Sino-Korean

// TO-DOS:

// Reduce the range from 0 to 99 for Native numbers


import SwiftUI


struct SinoKorean: View {
    
    @State private var showAnswer = false
    @State private var buttonTitle = "Show Answer"
    var aNumber: String
    var answerString: String = ""
    let ones = ["", "일","이", "삼", "사", "오", "육", "칠", "팔", "구"]
    let placeValues = ["", "십","백","천","만","억","조"]
    
    
//    Get the length of our number
    func getNumberLength() -> Int {
        return aNumber.count
    }
    
//    Get all the place values matching the length of the number
//    If our number has 3 digits, it returns ["백", "십", ""]
    func getPlaceValues() -> [String]  {
        let length = getNumberLength()
        return Array(placeValues[0..<length].reversed())
    }
    
//    Returns all the unit names , if we have 123, it returns the array ["일", "이", "삼"]
    func getDigitNames() -> [String] {
        var digitNames : [String] = []
//      digit is of type Char
//      The method wholeNumberValue on Char returns an optional Int
        for digit in aNumber {
            
            if let digitValue = digit.wholeNumberValue {
                digitNames.append(ones[digitValue])
               
                
            } else { 
                print("Something went wrong")
            }
            
        }
        return digitNames
    }


    func convertNumber(number: String ) -> String {
        
        var convertedNumber = ""
        let length = getNumberLength()
        let placeValues = getPlaceValues()
        let digitNames = getDigitNames()
        
        
        if length < 2 {
            convertedNumber = digitNames[0].isEmpty ? "영" : digitNames[0]
        } else {
           
            for index in 0..<length  {
                
                let digitName = digitNames[index]
                let placeValue = placeValues[index]
                
                
                if digitName == "일" {
                    convertedNumber += (index == length-1 ) ? digitName : placeValue
                }

                else {
    
                    convertedNumber += digitName
                    convertedNumber += placeValue
                }

            }
           
        }
        return convertedNumber
    }
    

    var body: some View {
        
       
        VStack {
           
            
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
             
            }
    

        }
        
        VStack {
            if showAnswer {
                Text(convertNumber(number: aNumber)).font(.largeTitle)
                    
            }
        }
        
    }
}

struct NativeKorean: View {
    
    @State private var showAnswer = false
    @State private var buttonTitle = "Show Answer"
    
    var aNumber: String
    let ones = ["","하나", "둘", "셋", "넷", "다섯", "여섯", "일홉", "여덟", "아홉"]
    let tens = ["", "열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
    
    //    Get the length of our number
    func getNumberLength() -> Int {
            return aNumber.count
        }

    func convertNumber(number: String) -> String {
        
        var convertedNumber = ""
        let length = getNumberLength()
        
        
        if length < 2  {
            
            if let index = Int(aNumber) {
                convertedNumber = (index == 0) ? "공" : ones[index]
            }
        } else {
            
            if let firstDigit = Int(aNumber.prefix(1)), let secondDigit = Int(aNumber.suffix(1)) {
                
                convertedNumber += tens[firstDigit] + ones[secondDigit]

            }
        }

        return convertedNumber
        
        
    }


    
    var body: some View {
        
        var showAnswer = false
        VStack {
            
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
             
            }
            
            if showAnswer {
                Text(convertNumber(number: aNumber))
            }

           
        }
    }
}


struct ContentView: View {
    
    //    Options for the variables
    //    Range between minNumber and maxNumber
    //    The number type:  Native or Sino-Korean
    
    @State private var typeOptions = ["Native-Korean","Sino-Korean"]
    @State private var numberType = ""
    @State private var minNumber = 1
    @State private var maxNumber = 99
    
    //    The generated number
    //    The answer i.e. the Korean spelling of the number
    
    @State private var currentNumber = ""
    @State private var answer = ""
    @State private var isShown = false
    
    //    Error handling for the ranges
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    
    
    
    var body: some View {
        
        List {
            Section("Conditions") {
                VStack {
                    Text("Choose a number type")
                    
                    Picker("Number Type", selection: $numberType) {
                        ForEach(typeOptions, id: \.self) { type in
                            Text(type)
                        }
                    }.pickerStyle(.segmented)
                    
                    
                    
                    HStack {
                        
                        
                        TextField("Minimum", value: $minNumber, format: .number)
                            .keyboardType(.numberPad)
                        
                        TextField("Maximum", value: $maxNumber, format: .number)
                            .keyboardType(.numberPad)
                        
                    }
                    
                    
                    
                }
            }
            Section("Your number") {
                HStack {
                    Button("Generate") {
                        currentNumber = generateNumber()
                    }
                }
             
                Text("\(currentNumber)")
            }
            
            Section("\(numberType)") {
                
                if numberType == "Sino-Korean" {
                    SinoKorean(aNumber: currentNumber )
                    
                }
                
                else if numberType == "Native-Korean"{
                    
                    NativeKorean(aNumber: currentNumber)
                }
                
                else {
                    
                }
                
                
                
            }
        } .alert(errorTitle, isPresented: $showingError) { } message: {
            Text(errorMessage)
        }
    }
        
        

        func generateNumber() -> String {
            
            
            guard arePositive(min: minNumber, max: maxNumber)  else {
                
                rangeError(title: "Negative number detected", message: "Please enter positive numbers")
                
                return ""
                
            }
            
            guard areWithinLimit(min: minNumber, max: maxNumber) else {
                rangeError(title: "Big number detected", message: "Please enter a number below 1 billion")
              
                
                return ""
             }
            
            guard coherentRange(min: minNumber, max: maxNumber) else {
                rangeError(title: "Incoherent range", message: "The minimum must be smaller or equal than the  maximum")
              
                
                return ""
             }
            
            let generatedNumber = Int.random(in: minNumber...maxNumber)
            
            return String(generatedNumber)
            
            
        }
        
        //        Check if the inputted numbers are positive
        func arePositive(min: Int, max: Int) -> Bool {
            
            
            let result = (min >= 0) && (max >= 0) ? true : false
            return result
            
            
        }
    
//        TextField limit maybe is better?
        func areWithinLimit(min: Int, max: Int) -> Bool {
            
            let limit: Int = 1000000
            let result = (min < limit) && (max < limit) ? true : false
            return result
            
        }
    
        func coherentRange(min: Int, max: Int) -> Bool {
            let result = (min <= max)
            return result
        }
    
        
        func rangeError(title: String, message: String) {
            
            errorTitle = title
            errorMessage = message
            showingError = true
        }
    }

    
    
        


#Preview {
    ContentView()
}
