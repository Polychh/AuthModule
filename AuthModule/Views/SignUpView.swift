//
//  SignUpView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = .init()
    @State var password: String = .init()
    @State var nickName: String = .init()
    @State var conformPasswod: String = .init()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment:.center, spacing: 16){
            Spacer()
            CustomTextField(text: $nickName, isSecureField: false, placeHolder: "Enter Name", promptTitle: "Name")
            CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address")
            CustomTextField(text: $password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password")
            CustomTextField(text: $conformPasswod, isSecureField: true, placeHolder: "Conform password", promptTitle: "Password")
            
            CustomButton(action: {
                print("Done")
            }, title: "SIGN UP")
            .padding(.top, 12)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                ButtonLinkView(title: "Already have an account?", subTitle: "Sign In")
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignUpView()
}
