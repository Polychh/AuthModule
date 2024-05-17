//
//  HomeViewModel.swift
//  AuthModule
//
//  Created by Polina on 17.05.2024.
//

import Foundation
import Combine

final class ResetViewModel: ObservableObject{
    @Published var email: String = .init()
    @Published var emailEndEditing: Bool = false
    @Published private var isValidEmail: Bool = true
    @Published var canSubmit: Bool = false
    
    private var anyCancellable: [AnyCancellable] = []
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    
    var emailPrompt: String? {
        if isValidEmail == true {
            return nil
        } else {
            return "Email incorrect, example test@tet.com"
        }
    }
    
    init(){
        validateRegInfo()
    }
    
    private func validateRegInfo(){
        $emailEndEditing
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map {isEmail in
                if isEmail{
                    self.canSubmit = true
                    return self.emailPredicate.evaluate(with: self.email)
                } else {
                    self.canSubmit = false
                    return true
                }
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &anyCancellable)
    }
}
