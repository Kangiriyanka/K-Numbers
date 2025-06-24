//
//  InfoView.swift
//  KoreanNumbers
//
//  Created by Kangiriyanka The Single Leaf on 2025/06/18.
//

import SwiftUI
import StoreKit
struct InfoView: View {
    @Environment(\.requestReview) var requestReview
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.customKoreanBlue.opacity(0.5), Color.customKoreanYellow.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment: .leading) {
                
                
                
                Group {
                    Text("Key Points").font(.title2).bold()
                    Text(" 1. The numbers for Sino-Korean stop at 조.")
                    
                    Text(" 2. In daily conversation, we omit the 일 prefix if the leftmost digit is 1. For example, 10 000 is either 일만 or 만.")
                    
                    Text("3. Zero (영 - 공) has no Native-Korean form. However, in the app, 공 is mapped to the Native-Korean form.")
                    
                    Text("4. I've added a space between the big numbers positions (만, 억, 조) for readability." )
                    
                    Text("5. Try to practice when you have a little of free time ☺️." )
                    Text("6. Please rate the app if you find it useful!" )
                    
                    
                    Button("Review the app") {
                        requestReview()
                    }
                    .padding()
                    
                    .buttonStyle(BlueButton())
                    
                    
                }
                .padding()
                .fontWeight(.semibold)
                .font(.body)
                
                
                
                
                
                
            }
        
                
                
                
                
            }
        }
     
        
        
        
        
    }
    


#Preview {
    InfoView()
}
