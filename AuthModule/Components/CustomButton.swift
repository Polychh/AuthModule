//
//  SignButton.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let title: String
    let isAddImage: Bool
    
    var body: some View {
        VStack{
            Button {
                action()
            } label: {
                HStack(alignment: .center, spacing: 5){
                    Text(title)
                    if isAddImage{
                        Image(systemName: "arrow.right")
                    }
                }
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: 35)
               
            }
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            .tint(Color("CustomGreen"))
            
        }
        
    }
}

#Preview {
    CustomButton(action: {
        print("Done")
    }, title: "Press me", isAddImage: true)
}



