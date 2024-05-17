//
//  ResetPasswodView.swift
//  AuthModule
//
//  Created by Polina on 14.05.2024.
//

import SwiftUI

struct ResetPasswordView: View {
    //@State private var email: String = .init()
    @State private var showAlert = false
    @State private var showAlertError = false
    @State private var alertMessage: String = .init()
    @State private var isViewVisible = false
    //@Binding var isVisibleLogIn: Bool
    //@FocusState private var focusedField: Bool
    @StateObject var viewModelValid = ResetViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 16){
            CustomTextField(text: $viewModelValid.email, isSecureField: false, placeHolder: "Enter email to reset Passwod", promptTitle: "Email Address", errorMessage: viewModelValid.emailPrompt)
                //.focused($focusedField)
                .submitLabel(.done)
                .onChange(of: viewModelValid.email) { _ in
                    viewModelValid.emailEndEditing = false
                }
                .onSubmit {
                    viewModelValid.emailEndEditing = true
                }
            CustomButton(action: {
                Task{
                    try await viewModel.updatePassword(email: viewModelValid.email)
                }
            }, title: "Reset Password", isAddImage: false)
            .disabled(!viewModelValid.canSubmit)
            .padding(.top, 12)
            Spacer()
        }
        .padding(.top, 32)
        .padding(.horizontal, 16)
        .onReceive(viewModel.$updatePassword) { isUpdate in
            if isUpdate {
                alertMessage = "Link to reset password in your mail box"
                showAlert = true
            }
        }
        .onAppear {
//            viewModel.errorMessage = nil
            isViewVisible = true
        }
        .onDisappear {
            isViewVisible = false
            viewModel.errorMessage = nil
            //isVisibleLogIn = true
        }
        .onReceive(viewModel.$errorMessage, perform: { error in
            if let error, isViewVisible{
                print("ERROR HAPPEN")
                alertMessage = error
                showAlertError = true
            }
//            else{
//                showAlertError = false
//            }
        })
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .alert(alertMessage, isPresented: $showAlertError) {
            Button("OK", role: .cancel) {}
        }
    }
}


