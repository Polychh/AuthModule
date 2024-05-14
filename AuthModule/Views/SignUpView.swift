//
//  SignUpView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = .init()
    @State private var password: String = .init()
    @State private var nickName: String = .init()
    @State private var conformPassword: String = .init()
    @State private var showAlert = false
    @State private var alertMessage: String = .init()
    @State private var isViewVisible = false
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
            }, title: "SIGN UP", isAddImage: true)
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.9)
            .padding(.top, 12)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                ButtonLinkView(title: "Already have an account?", subTitle: "Sign In", textSize: 18)
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            isViewVisible = true
            viewModel.errorMessage = nil
        }
        .onDisappear {
            isViewVisible = false
            viewModel.errorMessage = nil
        }
        .onReceive(viewModel.$errorMessage, perform: { error in
            if let error, isViewVisible{
                print("Doone signup")
                alertMessage = error
                showAlert = true
            }
        })
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

// MARK: - Validation TextFields
extension  SignUpView: ValidationProtocol{
    var isValid: Bool {
        return !email.isEmpty && password.count > 5 && email.contains("@") && nickName.count > 2 && password == conformPassword
    }
}

#Preview {
    SignUpView()
}
