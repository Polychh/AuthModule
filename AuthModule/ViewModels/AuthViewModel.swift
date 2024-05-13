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

protocol ValidationProtocol{
    var isValid: Bool { get }
}

@MainActor
final class AuthViewModel: ObservableObject{
    @Published var session: FirebaseAuth.User?
    @Published var user: User?
    
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
            print("Error Sign IN \(error.localizedDescription)" )
        }
    }
    
  
    func signUp(email: String, password: String, nickName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.session = result.user
            let user = User(id: result.user.uid, nickName: nickName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await getUser()
        }catch{
            print("Eror Sign UP \(error.localizedDescription)")
        }
    }
    
    private func getUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.user = try? snapshot.data(as: User.self)
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.session = nil
            self.user = nil
        } catch {
            print("Sign Out Error \(error.localizedDescription)")
        }
    }
}
