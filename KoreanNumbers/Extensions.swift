//
//  Extensions.swift
//  KoreanNumbers
//
//  Created by Kangiriyanka The Single Leaf on 2025/06/12.
//
import SwiftUI

extension View {
//    Binding allows you to use a variable in a view somewhere else
//    onChange is triggered every time you enter a digit in the TextField
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
    func boldCenteredStyle() -> some View  {
        modifier(BoldCenteredText())
    }
    

}

extension Color {
    
    static let customKoreanBlue = Color(red: 0 / 255.0, green: 71 / 255.0, blue: 140 / 255.0)
    static let lightCustomKoreanBlue = Color(red: 141/255.0, green: 184/255.0, blue: 227/255.0)
    static let customKoreanYellow = Color(red: 233 / 255.0, green: 180 / 255.0, blue: 58 / 255.0)
}
