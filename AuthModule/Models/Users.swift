//
//  Users.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let nickName: String
    let email: String
}
