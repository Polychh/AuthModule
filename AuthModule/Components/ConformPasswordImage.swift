//
//  ConformPasswordImage.swift
//  AuthModule
//
//  Created by Polina on 14.05.2024.
//

import SwiftUI

struct ConformPasswordImage: View {
    let colorImage: Color?
    
    private var image: String{
        let image = colorImage == .red ? "xmark.circle.fill" : "checkmark.circle.fill"
        return image
    }

    var body: some View {
        if let colorImage{
            Image(systemName: image)
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundStyle(colorImage)
        }
    }
}

