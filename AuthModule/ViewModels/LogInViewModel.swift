//
//  LogInViewModel.swift
//  AuthModule
//
//  Created by Polina on 16.05.2024.
//

import Foundation
import Combine

final class LogInViewModel: ObservableObject{
    @Published var email: String = .init()
    @Published var password: String = .init()
    @Published var emailEndEditing: Bool = false
    @Published var passwordEndEding: Bool = false
    
    @Published var isValidEmail: Bool = true
    @Published var isValidPassword: Bool = true
    @Published var canSubmit: Bool = false
    
    private var anyCancellable: [AnyCancellable] = []
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    
    var emailPrompt: String? {
        isValidProperty(isValid: isValidEmail, prompt: "Email incorrect, example test@tet.com", value: email)
    }
    
    var passwordPrompt: String? {
        isValidProperty(isValid: isValidPassword, prompt: "Password incorrect,should be more than 5 symbol", value: password)
    }
    
    init(){
        validateRegInfo()
    }
    
    private func validateRegInfo(){
        $emailEndEditing
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {isEmail in
                if isEmail{
                    return self.emailPredicate.evaluate(with: self.email)
                } else {
                    return true
                }
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &anyCancellable)
        
        $passwordEndEding
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {isPassword in
                if isPassword{
                    return self.password.count > 5
                } else {
                    return true
                }
            }
            .assign(to: \.isValidPassword, on: self)
            .store(in: &anyCancellable)
        
        Publishers.CombineLatest($isValidEmail, $isValidPassword)
            .map{email, password in
                if self.passwordEndEding == true && self.emailEndEditing == true{
                    return (email && password )
                } else {
                    return false
                }
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &anyCancellable)
    }
    
    private func isValidProperty( isValid: Bool, prompt: String, value: String) -> String?{
        if isValid == true {
            return nil
        } else {
            return prompt
        }
    }
    
    
}
