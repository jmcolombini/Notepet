//
//  PetCardView.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 10/02/25.
//
import SwiftUI

struct PetCardView: View {
    var imageURL: UIImage
    var petName: String
    
    var body: some View {
        Image(uiImage: imageURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 370, height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Text(petName)
                            .font(.system(size: 28))
                        Spacer()
                    }
                }
                .padding(20)
                .foregroundStyle(.white)
                .fontWeight(.medium)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
    }
}
