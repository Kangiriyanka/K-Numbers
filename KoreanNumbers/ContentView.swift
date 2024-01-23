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
    
    var a_number: String
    
    let units = ["", "일","이", "삼", "사", "오", "육", "칠", "팔", "구"]
    let place_values = ["", "십","백","천","만","억","조"]
    
    
//    Get the length of our number
    func get_number_length() -> Int {
        return a_number.count
    }
    
//    Get all the place values matching the length of the number
//    If our number has 3 digits, it returns ["백", "십", ""]
    func get_place_values() -> [String]  {
        let length = get_number_length()
        return Array(place_values[0..<length].reversed())
    }
    
//    Returns all the unit names , if we have 123, it returns the array ["일", "이", "삼"]
    func get_digit_names() -> [String] {
        var digit_names : [String] = []
//      digit is of type Char
//      The method wholeNumberValue on Char returns an optional Int
        for digit in a_number {
            
            if let digitValue = digit.wholeNumberValue {
                digit_names.append(units[digitValue])
                print(digit_names)
                
            } else { print("Something went wrong")
                
            }
            
        }
        return digit_names
    }

    

    
    func convert_number() -> String {
        var converted_number = ""
        let length = get_number_length()
        let place_values = get_place_values()
        let digit_names = get_digit_names()
        
        
        if length < 2 {
            converted_number = digit_names[0].isEmpty ? "영" : digit_names[0]
        } else {
           
            var digit_name = ""
            var place_value = ""
            for index in 0..<length  {
                
                digit_name = digit_names[index]
               
                place_value = place_values[index]
                

                if digit_name == "일" {
                    if index == get_number_length() - 1 {
                        converted_number += digit_name
                    }
                    else {
                        converted_number += place_value
                    }
                 
                }
                
                else if digit_name == "" {
                    converted_number += digit_name
                }
                
                
                else {
    
                    converted_number += digit_name
                    converted_number += place_value
                }

            }
           
        }
        return converted_number
    }
    

    var body: some View {
        
        VStack {
           
            
            Button("Show Answer") {
               
                print(convert_number())
             
            }

        }
        
    }
}

struct NativeKorean: View {

    var a_number: String
    
    let units = ["","하나", "둘", "셋", "넷", "다섯", "여섯", "일홉", "여덟", "아홉"]
    let tens = ["", "열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
    
    //    Get the length of our number
    func get_number_length() -> Int {
            return a_number.count
        }

    func convert_number() -> String {
        
        var convertedNumber = ""
        let length = get_number_length()
        
        if length < 2  {
            let index = Int(a_number) ?? 0
            if index == 0 {
                convertedNumber = "공"
            }
            convertedNumber += units[index]
        }
        else {
            
            let first_digit =  Int(a_number.prefix(1)) ?? 0
            let second_digit = Int(a_number.suffix(1)) ?? 0
            
            convertedNumber += tens[first_digit]
            convertedNumber += units[second_digit]

        }

        return convertedNumber
        
        
    }


    
    var body: some View {
        
        var showAnswer = false
        VStack {
            
            Button("Show Answer") {
               
                 print(convert_number())
                 showAnswer.toggle()
                
               
            }
            
            if showAnswer {
                Text(convert_number())
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
                    SinoKorean(a_number: currentNumber )
                    
                }
                
                else if numberType == "Native-Korean"{
                    
                    NativeKorean(a_number: currentNumber)
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
