//
//  ResetPasswodView.swift
//  AuthModule
//
//  Created by Polina on 14.05.2024.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = .init()
    @State private var showAlert = false
    @State private var showAlertError = false
    @State private var alertMessage: String = .init()
    @Binding var isVisibleLogIn: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isViewVisible = false
    var body: some View {
        VStack(alignment: .center, spacing: 16){
            CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email to reset Passwod", promptTitle: "Email Address", errorMessage: nil)
            CustomButton(action: {
                Task{
                    try await viewModel.updatePassword(email: email)
                }
            }, title: "Reset Password", isAddImage: false)
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.7)
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
            isVisibleLogIn = true
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

// MARK: - Validation TextFields
extension ResetPasswordView: ValidationProtocol{
    var isValid: Bool {
        return !email.isEmpty
    }
}

