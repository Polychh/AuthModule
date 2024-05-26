//
//  AuthViewModel.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseCore
import GoogleSignIn

@MainActor
final class AuthViewModel: ObservableObject{
    @Published var session: FirebaseAuth.User?
    @Published var googleSession: GIDGoogleUser?
    @Published var user: User?
    @Published var updatePassword: Bool = false
    @Published var errorMessage: String?
    
    init(){
        self.session = Auth.auth().currentUser
        Task{
            await getUser()
        }
    }
    
    func signIn(email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.session = result.user
            await getUser()
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp(email: String, password: String, nickName: String) async throws{
        do{
            // If try to create user with already existing email catch error
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            sendVerificationEmail()
            self.session = result.user
            let user = User(id: result.user.uid, nickName: nickName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await getUser()
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func signInWithGoogle() async throws{
        do{
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            //Get RootView
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = scene?.windows.first?.rootViewController else { return }
            
            //Authentication response
            let result = try await GIDSignIn.sharedInstance.signIn( withPresenting: rootViewController)
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                throw "Unexpected error occurred, please retry"
            }
            
            //Firebase auth
            let credential = GoogleAuthProvider.credential( withIDToken: idToken, accessToken: user.accessToken.tokenString)
            let authResult = try await Auth.auth().signIn(with: credential)
            self.session = authResult.user
            
            // Save userInfo in db
            let userInfo = User(id: authResult.user.uid, nickName: authResult.user.email ?? "", email: authResult.user.email ?? "")
            let encodedUser = try Firestore.Encoder().encode(userInfo)
            try await Firestore.firestore().collection("users").document(userInfo.id).setData(encodedUser)
            await getUser()
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func signOut() {
        do {
            // Check if the user is signed in with Google
            if let _ = GIDSignIn.sharedInstance.currentUser {
                GIDSignIn.sharedInstance.signOut()
            }
            try Auth.auth().signOut()
            self.session = nil
            self.user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updatePassword(email: String) async throws{
        do{
            try await Auth.auth().sendPasswordReset(withEmail: email)
            updatePassword = true
        } catch {
            errorMessage = error.localizedDescription
        }
       
    }
    
    private func getUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("uid \(uid)")
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.user = try? snapshot.data(as: User.self)
        print(user)
    }
    
    private func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser else { return}
        
        if user.isEmailVerified {
            return
        }
        
        user.sendEmailVerification { error in
            if let _ = error {
                return
            }
        }
    }
}
