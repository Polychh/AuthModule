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
    @State var conformPassword: String = .init()
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment:.center, spacing: 16){
            Spacer()
            CustomTextField(text: $nickName, isSecureField: false, placeHolder: "Enter Name", promptTitle: "Name")
            CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address")
            CustomTextField(text: $password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password")
            ZStack(alignment: .trailing) {
                CustomTextField(text: $conformPassword, isSecureField: true, placeHolder: "Conform password", promptTitle: "Password")
                if !password.isEmpty && !conformPassword.isEmpty{
                    Group {
                        if password == conformPassword{
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                        } else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.semibold)
                                .foregroundStyle(.red)
                        }
                    }
                    .offset(x: -5, y: 12)
                }
            }
            
            CustomButton(action: {
                Task{
                    try await viewModel.signUp(email: email, password: password, nickName: nickName)
                }
            }, title: "SIGN UP")
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.7)
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

// MARK: - Validation TextFields
extension  SignUpView: ValidationProtocol{
    var isValid: Bool {
        return !email.isEmpty && password.count > 6 && email.contains("@") && nickName.count > 2 && password == conformPassword
    }
}

#Preview {
    SignUpView()
}
