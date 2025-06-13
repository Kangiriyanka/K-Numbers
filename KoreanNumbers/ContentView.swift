//
//  ContentView.swift
//  KoreanNumbers
//
//  Created by kangiriyanka on 2024/01/02.

// GOAL: Application that teaches how to say a number in Korean. The answer can be in either Native-Korean or Sino-Korean


import SwiftUI

// Styles
struct BoldCenteredText: ViewModifier {
    
    @State private var currentOpacity = 0.0
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        
        
        content
            .font(.title)
            .opacity(currentOpacity)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .foregroundStyle(colorScheme == .dark ? Color.lightCustomKoreanBlue : Color.customKoreanBlue)
            .bold()
            .onAppear {
                
                withAnimation(.spring(duration: 0.5)) {
                    currentOpacity = 1.0
                }
            }
        
    }
    
    
}


struct BlueButton: ButtonStyle {
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .bold()
            .frame( maxWidth: .infinity)
            .font(.title2)
        
            .background(Color.customKoreanYellow)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.customKoreanBlue, lineWidth: 2)
            )
        
            .foregroundStyle(Color.customKoreanBlue)
        
        
        
        
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        
    }
}






struct SinoKoreanView: View {
    
    @State private var showAnswer = false
    @State private var buttonTitle = "Show Answer"
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
    
    
    func convertNumber(number: String ) -> String {
        
        
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
    
    
    var body: some View {
        
        VStack {
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
                
            }.buttonStyle(BlueButton())
            
            
            
            
            if showAnswer  {
                
                //                The style is applied because of our little function in Extension view
                Text(convertNumber(number: sinoKoreanNumber))
                    .boldCenteredStyle()
            }
            
            
        }.padding(10)
        
    }
}


struct NativeKoreanView: View {
    
    @State private var showAnswer = false
    @State private var buttonTitle = "Show Answer"
    
    var nativeKoreanNumber: String
    
    let ones = ["", "하나", "둘", "셋", "넷", "다섯", "여섯", "일곱", "여덟", "아홉"]
    let tens = ["", "열", "스물", "서른", "마흔", "쉰", "예순", "일흔", "여든", "아흔"]
    
    //    Get the length of our number
    func getNumberLength() -> Int {
        return nativeKoreanNumber.count
    }
    
    func convertNumber(number: String) -> String {
        
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
    
    
    
    var body: some View {
        
        VStack {
            Button(buttonTitle) {
                
                buttonTitle = showAnswer ? "Show Answer" : "Hide Answer"
                showAnswer.toggle()
                
                
            }
            .buttonStyle(BlueButton())
           
            
            
            
            if showAnswer  {
                
                Text(convertNumber(number: nativeKoreanNumber))
                    .boldCenteredStyle()
                
                
                
                
                
                
            }
        }.padding(10)
    }
    
    
    
}


struct ContentView: View {
    
    //    Options for the variables
    //    Range between minNumber and maxNumber
    //    The number type:  Native or Sino-Korean
    @Environment(\.colorScheme) var colorScheme
    
    @State private var typeOptions = ["Native-Korean", "Sino-Korean"]
    @State private var numberType = "Native-Korean"
    @State private var minNumber = 0
    @State private var maxNumber = 0
    @FocusState var isInputActive: Bool
    
    
    //    The generated number
    //    The answer i.e. the Korean spelling of the number
    
    @State private var currentNumber = "0"
    @State private var answer = ""
    
    
    //    Error handling for the ranges
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    
    //     Animations
    @State private var transitionNumber = false
    
    
    
    
    
    
    var body: some View {
        
        
        NavigationStack {
            
            List {
                
                
                Section("Type & Number Range") {
                    VStack {
                        
                        
                        
                        Picker("Number Type", selection: $numberType) {
                            ForEach(typeOptions, id: \.self) { type in
                                
                                Text(type)
                                
                            }
                            
                        }
                            .pickerStyle(.segmented)
                            .accessibilityLabel("Number Type")
                            .tint(.red)
                            .background(Color.customKoreanYellow)
                            .foregroundStyle(Color.customKoreanBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                          
                        
                        
                        
                        
                            .onChange(of: numberType) {
                                
                                
                                resetNumbers()
                            }
                        
                        
                        HStack {
                            
                            //                                Optional View Rendering
                            
                            if numberType == "Sino-Korean" {
                                
                                
                                TextField("Minimum", value: $minNumber, format: .number)
                                    .keyboardType(.numberPad)
                                    .limitDigits($minNumber, to: 13)
                                    .bold()
                                    .padding()
                                    .focused($isInputActive)
                                    .foregroundStyle(colorScheme == .dark ? Color.lightCustomKoreanBlue : Color.customKoreanBlue)
                                
                                
                                
                                
                                
                                
                                TextField("Maximum", value: $maxNumber, format: .number)
                                    .keyboardType(.numberPad)
                                    .limitDigits($maxNumber, to: 13)
                                    .bold()
                                
                                    .padding()
                                    .focused($isInputActive)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button("Done") {
                                                isInputActive = false
                                            }
                                        }
                                    }
                                    .foregroundStyle(colorScheme == .dark ? Color.lightCustomKoreanBlue : Color.customKoreanBlue)
                                
                                
                                
                                
                                
                                
                            }
                            
                            if numberType == "Native-Korean" {
                                
                                
                                Picker("Minimum:", selection: $minNumber) {
                                    ForEach((0..<100), id: \.self) {
                                        Text("\($0) ")
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(colorScheme == .dark ? Color.lightCustomKoreanBlue : Color.customKoreanBlue)
                                .bold()
                                .padding(2)
                                
                                Picker("Maximum:", selection: $maxNumber) {
                                    ForEach((0..<100), id: \.self) {
                                        Text("\($0) ")
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(colorScheme == .dark ? Color.lightCustomKoreanBlue : Color.customKoreanBlue)
                                .bold()
                                .padding(2)
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                        
                        Button("Generate") {
                            currentNumber = generateNumber()
                            transitionNumber.toggle()
                            
                        }
                        .buttonStyle(BlueButton())
                    }
                    
                    
                    
                }.padding(2)
                    .listRowBackground(Color.customKoreanYellow.opacity(0.2))
                
                
                
                
                
                
                Section("Your number") {
                    
                    
                    
                    Text("\(currentNumber)")
                    
                    
                        .transition(.move(edge: .bottom))
                        .boldCenteredStyle()
                        
                    
                    
                    
                    
                    
                } .listRowBackground(Color.customKoreanYellow.opacity(0.2))
                
                Section("\(numberType)") {
                    
                    
                    if numberType == "Sino-Korean" {
                        SinoKoreanView(sinoKoreanNumber: currentNumber)
                        
                    }
                    
                    if numberType == "Native-Korean"{
                        
                        NativeKoreanView(nativeKoreanNumber: currentNumber)
                    }
                } .listRowBackground(Color.customKoreanYellow.opacity(0.2))
                
                
                
            }
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.customKoreanBlue.opacity(0.5), Color.customKoreanYellow.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            )
            
            
            
            
            
            .navigationTitle("Korean Numbers")
            
            
            
            
        }
        
        .alert(errorTitle, isPresented:$showingError) { } message: {
            Text(errorMessage)
        }
        
    }
    
    
    //   --  Functions --
    
    //    Reset the numbers if an error occurs
    func resetNumbers() {
        
        currentNumber = "0"
        maxNumber = 0
        minNumber = 0
        
        
        
    }
    
    
    //    Returns a random number String based on the user selected range
    //    Before generating the number
    //    Check if numbers are positive and if the range is coherent
    //    Change the error message and error titles and reset numbers.
    
    func generateNumber() -> String {
        
        
        guard coherentRange(min: minNumber, max: maxNumber) else {
            alertError(title: "Incoherent range", message: "The minimum must be smaller or equal than the  maximum")
            resetNumbers()
            
            
            return "0"
        }
        
        let generatedNumber = Int.random(in: minNumber...maxNumber)
        return String(generatedNumber)
        
        
    }
    
    
    
    //    Ensure that  the  minimum number stays below the maximum number
    func coherentRange(min: Int, max: Int) -> Bool {
        
        let result = min <= max
        return result
    }
    
    
    //    Tell the user what kind of error occured
    func alertError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}






#Preview {
    ContentView()
}
