//
//  GoogleButton.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct GoogleButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image("googleIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

#Preview {
    GoogleButton{
        print("Done")
    }
}
