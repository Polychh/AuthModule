//
//  ContentView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct LoginView: View {
    @State var email: String
    @State var password: String
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 16){
                Spacer()
                CustomTextField(text: $email, isSecureField: false, placeHolder: "Enter email", promptTitle: "Email Address")
                CustomTextField(text: $password, isSecureField: true, placeHolder: "Enter password", promptTitle: "Password")
                
                CustomButton(action: {
                    print("Done")
                }, title: "SIGN IN")
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

#Preview {
    LoginView(email: "", password: "")
}
