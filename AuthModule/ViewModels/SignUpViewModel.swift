//
//  SignUpViewModel.swift
//  AuthModule
//
//  Created by Polina on 15.05.2024.
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject{
    @Published var email: String = .init()
    @Published var nickName: String = .init()
    @Published var password: String = .init()
    @Published var conformPassword: String = .init()
    
    @Published private var isValidNickName = false
    @Published private var isValidPassword = false
    @Published private var isValidConformPassword = false
    @Published private var isValidEmail = false
    @Published var canSubmit: Bool = false
    
    var emailPrompt: String? {
        isValidProperty(property: email, isValid: isValidEmail, prompt: "Email incorrect, example test@tet.com")
    }
    
    var nickNamePrompt: String? {
        isValidProperty(property: nickName, isValid: isValidNickName, prompt: "NickName incorrect, should be more than 3 symbol")
    }
    
    var passwordPrompt: String? {
        isValidProperty(property: password, isValid: isValidPassword, prompt: "Password incorrect,should be more than 5 symbol")
    }
    
    var conformImagePrompt: Color?{
        if conformPassword.isEmpty{
            return nil
        } else if isValidConformPassword == true{
            return .green
        } else {
            return .red
        }
    }
    
    
    private var anyCancellable: [AnyCancellable] = []
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    
    
    init(){
        validateRegInfo()
    }

    private func validateRegInfo(){
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {email in
                    return self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &anyCancellable)
        $nickName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {nickName in
                return nickName.count > 2
            }
            .assign(to: \.isValidNickName, on: self)
            .store(in: &anyCancellable)
        
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {password in
                return password.count > 5
            }
            .assign(to: \.isValidPassword, on: self)
            .store(in: &anyCancellable)
        
        $conformPassword
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { conformPassword in
                guard !conformPassword.isEmpty else {
                    return false
                }
                return conformPassword == self.password
            }
            .assign(to: \.isValidConformPassword, on: self)
            .store(in: &anyCancellable)
     
        Publishers.CombineLatest4($isValidEmail, $isValidPassword, $isValidNickName, $isValidConformPassword)
            .map{email, password, nickName, conformPassword in
                return (email && password && nickName && conformPassword)
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &anyCancellable)
    }
    
    private func isValidProperty(property: String, isValid: Bool, prompt: String) -> String?{
        if property.isEmpty || isValid == true{
            return nil
        } else {
            return prompt
        }
    }
}
