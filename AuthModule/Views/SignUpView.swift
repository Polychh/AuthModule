//
//  SignUpView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct SignUpView: View {
    enum FocusedField {
        case email, password, nickname, conformPassword
    }
    @State private var showAlert = false
    @State private var alertMessage: String = .init()
    @State private var isViewVisible = false
    @FocusState private var focusedField: FocusedField?
    @StateObject var viewModelValid = SignUpViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment:.center, spacing: 16){
            Spacer()
            CustomTextField(text: $viewModelValid.nickName, isSecureField: false, placeHolder: "Enter Name", promptTitle: "Name", errorMessage: viewModelValid.nickNamePrompt )
                .focused($focusedField, equals: .nickname)
                .submitLabel(.next)
            CustomTextField(text: $viewModelValid.email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address", errorMessage: viewModelValid.emailPrompt)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
            CustomTextField(text: $viewModelValid.password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password", errorMessage: viewModelValid.passwordPrompt)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
            ZStack(alignment: .trailing) {
                CustomTextField(text: $viewModelValid.conformPassword, isSecureField: true, placeHolder: "Conform password", promptTitle: "Password", errorMessage: nil)
                    .focused($focusedField, equals: .conformPassword)
                    .submitLabel(.done)
                if !viewModelValid.password.isEmpty && !viewModelValid.conformPassword.isEmpty{
                    ConformPasswordImage(colorImage: viewModelValid.conformImagePrompt)
                        .offset(x: -8, y: 12)
                  }
            }
            
            CustomButton(action: {
                Task{
                    try await viewModel.signUp(email: viewModelValid.email, password: viewModelValid.password, nickName: viewModelValid.nickName)
                }
            }, title: "SIGN UP", isAddImage: true)
            .disabled(!viewModelValid.canSubmit )
            .padding(.top, 12)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                ButtonLinkView(title: "Already have an account?", subTitle: "Sign In", textSize: 18)
                    .padding(.bottom, 8)
            }
            
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.errorMessage = nil
            isViewVisible = true
        }
        .onSubmit {
            if focusedField == .nickname {
                focusedField = .email
            }else if  focusedField == .email{
                focusedField = .password
            } else if  focusedField == .password{
                focusedField = .conformPassword
            } else {
                focusedField = nil
            }
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

