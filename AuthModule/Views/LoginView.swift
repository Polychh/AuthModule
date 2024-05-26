//
//  ContentView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct LoginView: View {
    enum FocusedField {
        case email, password
    }
    @State private var showingSheet = false
    @State private var showAlert = false
    @State private var alertMessage: String = .init()
    @State private var isViewVisible = false
    @StateObject var viewModelValid = LogInViewModel()
    @FocusState private var focusedField: FocusedField?
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        //NavigationStack{
            VStack(alignment: .center, spacing: 16){
                Spacer()
                VStack(spacing: 16){
                    CustomTextField(text: $viewModelValid.email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address", errorMessage: viewModelValid.emailPrompt)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onChange(of: viewModelValid.email) { _ in
                            viewModelValid.emailEndEditing = false
                        }
                    CustomTextField(text:  $viewModelValid.password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password", errorMessage: viewModelValid.passwordPrompt)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onChange(of: viewModelValid.password) { _ in
                            viewModelValid.passwordEndEding = false
                        }
                }
                .onSubmit {
                    if focusedField == .email {
                        focusedField = .password
                        viewModelValid.emailEndEditing = true
                    } else if focusedField == .password {
                        viewModelValid.passwordEndEding = true
                        focusedField = nil
                    }
                }
              
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
                        ResetPasswordView()
                    }
                }
                
                CustomButton(action: {
                    Task{
                        try await viewModel.signIn(email: viewModelValid.email, password: viewModelValid.password)
                    }
                }, title: "SIGN IN", isAddImage: true)
                .disabled(!viewModelValid.canSubmit)
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
       // }
    }
}


