//
//  ContentView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
            if viewModel.session != nil{
                SuccessView()
            } else {
                LoginView()
            }
        }
    }
}

