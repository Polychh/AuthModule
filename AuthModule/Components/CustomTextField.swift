//
//  CustomTextField.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let isSecureField: Bool
    let placeHolder: String
    let promptTitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(promptTitle)
                .foregroundStyle(.gray)
                .font(.callout)
                .fontWeight(.medium)
            if isSecureField{
                SecureField(placeHolder, text: $text)
                    .font(.system(size: 16,weight: .regular))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(.gray)
                    .modifier(TextFieldModifier(roundCorners: 10, gradientFirstColor: Color("CustomPink"), gradientSecondColor: Color("CustomGreen")))
            } else{
                TextField(placeHolder, text: $text)
                    .font(.system(size: 16,weight: .regular))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(.gray)
                    .modifier(TextFieldModifier(roundCorners: 10, gradientFirstColor: Color("CustomPink"), gradientSecondColor: Color("CustomGreen")))
            }
        }
    }
}

#Preview {
    CustomTextField(text: .constant(""), isSecureField: true, placeHolder: "Enter email", promptTitle: "Email Address")
}
