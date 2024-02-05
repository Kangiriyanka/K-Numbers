//
//  ContentView.swift
//  KoreanNumbers
//
//  Created by kangiriyanka on 2024/01/02.

// GOAL: Application that teaches how to say a number in Korean. The answer can be in either Native-Korean or Sino-Korean


import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .listRowBackground(Color.clear)
            .padding()
           
    }
}


extension View {
    func limitDigits(_ number: Binding<Int>, to digitLimit: Int) -> some View {
        self
            .onChange(of: number.wrappedValue) {
                let numberString = String(number.wrappedValue)
                if numberString.count > digitLimit {
                    let shortenedNumber = String(numberString.prefix(digitLimit))
                    
                    number.wrappedValue  = Int(shortenedNumber) ?? 0
                }
            }
    }
    func titleStyle() -> some View  {
        modifier(Title())
    }
    
    
}



struct SinoKorean: View {
    
    @State private var showAnswer = false
    @State private var buttonTitle = "Show Answer"
    var aNumber: String
    
    var answerString: String = ""
    let ones = ["", "일","이", "삼", "사", "오", "육", "칠", "팔", "구"]
    let placeValues = ["", "십","백","천","만","억","조"]
    
    
    //    Get the length of our number0
    func getNumberLength() -> Int {
        return aNumber.count
    }
    
    //    Get all the place values matching the length of the number
    //    If our number has 3 digits, it returns ["백", "십", ""]
    
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
        return digitNames.reversed()
    }
    
    
    func convertNumber(number: String ) -> String {
        
        var convertedNumber = ""
        var groupIndex = 0
        let length = getNumberLength()
        let digitNames = getDigitNames()
        
        
        if length < 2 {
            convertedNumber = digitNames[0] == "" ? "영" : digitNames[0]
        } else {
            
            
            for index in 0 ..< length {
                
                if index % 4 == 0 && index > 0 {
                    
                    convertedNumber +=
                    (digitNames[index] == "일") ?
                    
                    " " + placeValues[4 + groupIndex] :
                    " " + placeValues[4 + groupIndex] + digitNames[index ]
                    
                    groupIndex += 1
                }
                
                else {
                    //                    Different logic for 1
                    if index > 0 && digitNames[index] == "일" {
                        convertedNumber += placeValues[ index % 4 ]
                    }
                    else {
                        
                        convertedNumber += (digitNames[index] != "") ?   placeValues[index % 4 ] +  digitNames[index] : ""
                        
                        
                    }
                    
                }
                
            }
            
        }
        return String(convertedNumber.reversed())
    }
    
    
    var body: some View {
        
        
        VStack {
            
            
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
                
            }.buttonStyle(BlueButton())
            
            
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
        
        
        
        VStack {
            
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
                
            }.buttonStyle(BlueButton())
            
            VStack {
                
                if showAnswer {
                    Text(convertNumber(number: aNumber)).font(.largeTitle)
                    
                }
            }
            
            
        }
    }
}



struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.9), value: configuration.isPressed)
    }
}



struct ContentView: View {
    
    //    Options for the variables
    //    Range between minNumber and maxNumber
    //    The number type:  Native or Sino-Korean
    
    @State private var typeOptions = ["Native-Korean","Sino-Korean"]
    @State private var numberType = ""
    @State private var minNumber = 0
    @State private var maxNumber = 0
    
    
    
    
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
                        .onChange(of: numberType) {
                            // Reset minNumber and maxNumber to 0 when the numberType changes
                            resetNumbers()
                        }
                    
                    
                    HStack {
                        
                        if numberType == "Sino-Korean" {
                            
                            
                            TextField("Minimum", value: $minNumber, format: .number)
                                .keyboardType(.numberPad)
                                .limitDigits($minNumber, to: 13)
                            
                            
                            TextField("Maximum", value: $maxNumber, format: .number)
                                .keyboardType(.numberPad)
                                .limitDigits($maxNumber, to: 13)
                            
                        }
                        
                        if numberType == "Native-Korean" {
                            
                            
                            Picker("Minimum Number", selection: $minNumber) {
                                ForEach(0..<100) {
                                    Text("\($0) ")
                                }
                            }
                            Picker("Maximum Number", selection: $maxNumber) {
                                ForEach(0..<100) {
                                    Text("\($0) ")
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            Button("Generate") {
                currentNumber = generateNumber()
            }
            .buttonStyle(BlueButton())
            Section("Your number") {
                
                
                Text("\(currentNumber)").titleStyle()
            }
            
            Section("\(numberType)") {
                
                if numberType == "Sino-Korean" {
                    SinoKorean(aNumber: currentNumber )
                    
                }
                
                if numberType == "Native-Korean"{
                    
                    NativeKorean(aNumber: currentNumber)
                }
                
                
                
                
            }
        } .alert(errorTitle, isPresented: $showingError) { } message: {
            Text(errorMessage)
        }
    }
    
    
    //   --  Functions --
    
    //    Reset the numbers if an error occurs
    func resetNumbers() {
        maxNumber = 0
        minNumber = 0
        
    }
    
    func generateNumber() -> String {
        
        
        guard arePositive(min: minNumber, max: maxNumber)  else {
            
            rangeError(title: "Negative number detected", message: "Please enter positive numbers")
            
            resetNumbers()
            
            return ""
            
        }
        
        
        
        guard coherentRange(min: minNumber, max: maxNumber) else {
            rangeError(title: "Incoherent range", message: "The minimum must be smaller or equal than the  maximum")
            resetNumbers()
            
            
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
    
    func coherentRange(min: Int, max: Int) -> Bool {
        let result = min <= max
        print(result)
        
        
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
