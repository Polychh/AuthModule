//
//  ContentView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = .init()
    @State private var password: String = .init()
    @State private var showingSheet = false
    @State private var showAlert = false
    @State private var alertMessage: String = .init()
    @State private var isViewVisible = false
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 16){
                Spacer()
                CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address", errorMessage: nil)
                CustomTextField(text: $password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password", errorMessage: nil)
                
                HStack{
                    Spacer()
                    Button {
                        viewModel.errorMessage = nil
                        isViewVisible = false
                        showingSheet.toggle()
                    } label: {
                        ButtonLinkView(title: "Forgot password?", subTitle: "Press", textSize: 14)
                    }
                    .sheet(isPresented: $showingSheet) {
                        ResetPasswordView(isVisibleLogIn: $isViewVisible)
                    }
                }
                
                CustomButton(action: {
                    Task{
                        try await viewModel.signIn(email: email, password: password)
                    }
                }, title: "SIGN IN", isAddImage: true)
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.9)
                .padding(.top, 12)
                
                GoogleButton {
                    Task{
                        try await viewModel.signInWithGoogle()
                    }
                }
                
                .padding(.top, 24)
                
                Spacer()
            
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    ButtonLinkView(title: "Do not have an account?", subTitle: "Sign Up", textSize: 18)
                        .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 16)
            .onAppear {
                isViewVisible = true
            }
            .onDisappear {
                isViewVisible = false
            }
            .onReceive(viewModel.$errorMessage, perform: { error in
                if let error, isViewVisible{
                    alertMessage = error
                    showAlert = true
                }
            })
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
// MARK: - Validation TextFields
extension LoginView: ValidationProtocol{
    var isValid: Bool {
        return !email.isEmpty && password.count > 6 && email.contains("@")
    }
}

