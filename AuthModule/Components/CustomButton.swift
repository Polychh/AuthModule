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
    
    var body: some View {
        VStack{
            Button {
                action()
            } label: {
                HStack(alignment: .center, spacing: 5){
                    Text(title)
                    Image(systemName: "arrow.right")
                }
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width - 64, height: 30 )
            }
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            .tint(Color("CustomGreen")).opacity(0.9)
        }
    }
}


#Preview {
    CustomButton(action: {
        print("Done")
    }, title: "Go")
}
