//
//  UserInfoView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct UserInfoView: View {
    let placeHolder: String
    let text: String
    var body: some View {
        HStack(spacing: 0){
            Text(placeHolder)
                .foregroundStyle(.gray)
                .fontWeight(.medium)
            Spacer()
            Text(text)
                .foregroundStyle(.black)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    UserInfoView(placeHolder: "NickName", text: "Polych")
}
