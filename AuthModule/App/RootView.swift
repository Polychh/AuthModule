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
        NavigationStack {
            if viewModel.session != nil {
                PhotoView()
            } else {
                LoginView()
            }
        }
    }
}

