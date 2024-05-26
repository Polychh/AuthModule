//
//  SuccessView.swift
//  AuthModule
//
//  Created by Polina on 13.05.2024.
//

import SwiftUI
import PhotosUI
struct PhotoView: View {
    @StateObject var imageViewModel = ImageSetterViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let user = viewModel.user {
                VStack(spacing: 8) {
                    if let image = imageViewModel.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray)
//                            .background {
//                                Color.red
//                            }
                    }
                    UserInfoView(placeHolder: "NickName", text: user.nickName)
                        .padding(.top, 32)
                    UserInfoView(placeHolder: "Email", text: user.email)
                    Spacer()
                    CustomButton(action: {
                        viewModel.signOut()
                    }, title: "SIGN OUT", isAddImage: true)
                    .padding([.top, .bottom], 8)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundStyle(.customGreen)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
//        .background {
//            Color.green
//        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PhotosPicker(selection: $imageViewModel.imageSelection) {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

