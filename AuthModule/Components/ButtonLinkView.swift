//
//  ButtonLinkView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct ButtonLinkView: View {
    let title: String
    let subTitle: String
    var body: some View {
        HStack(alignment: .center, spacing: 2){
            Text(title)
                .fontWeight(.regular)
            Text(subTitle)
                .fontWeight(.bold)
        }
        .font(.title3)
        .foregroundStyle(.gray)
    }
}

