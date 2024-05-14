//
//  SuccessView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.user{
            VStack(alignment: .center, spacing: 16){
                UserInfoView(placeHolder: "NickName", text: user.nickName)
                UserInfoView(placeHolder: "Email", text: user.email)
                CustomButton(action: {
                    viewModel.signOut()
                }, title: "SIGN OUT", isAddImage: true)
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
        }else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundStyle(.customGreen)
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    SuccessView()
}
