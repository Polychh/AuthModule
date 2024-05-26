//
//  ImageSetterViewModel.swift
//  AuthModule
//
//  Created by Polina on 25.05.2024.
//

import SwiftUI
import PhotosUI

@MainActor
final class ImageSetterViewModel: ObservableObject{
    @Published var image: Image?
    @Published var imageSelection: PhotosPickerItem? {
        didSet{
            if let imageSelection{
                Task{
                    try await loadTransforable(from: imageSelection)
                }
            }
        }
    }
    
    func loadTransforable( from imageSelection: PhotosPickerItem?) async throws{
        do{
            if let data = try await imageSelection?.loadTransferable(type: Data.self){
                guard let uiImage = UIImage(data: data) else { return }
                self.image = Image(uiImage: uiImage)
            }
        }catch{
            print(error.localizedDescription)
            image = nil
        }
    }
}
