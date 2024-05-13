//
//  ContentView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = .init()
    @State var password: String = .init()
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 16){
                Spacer()
                CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address")
                CustomTextField(text: $password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password")
                
                CustomButton(action: {
                    Task{
                        try await viewModel.signIn(email: email, password: password)
                    }
                }, title: "SIGN IN")
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.7)
                .padding(.top, 12)
                
                Spacer()
            
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    ButtonLinkView(title: "Do not have an account?", subTitle: "Sign Up")
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
// MARK: - Validation TextFields
extension LoginView: ValidationProtocol{
    var isValid: Bool {
        return !email.isEmpty && password.count > 6 && email.contains("@")
    }
}

#Preview {
    LoginView()
}
