//
//  AuthModuleApp.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct AuthModuleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
        }
    
    }
}

