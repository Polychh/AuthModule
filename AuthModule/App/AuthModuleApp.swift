//
//  AuthModuleApp.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI
import FirebaseCore

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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
