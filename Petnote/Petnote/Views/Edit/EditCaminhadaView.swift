//
//  EditCaminhadaView.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 27/02/25.
//

import SwiftUI
import MapKit

struct EditCaminhadaView: View {
    @Bindable var caminhada: Caminhada
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Button{
                    dismiss()
                } label: {
                    Text("Feito")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
                Text("Dados do passeio")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Feito")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
            }
            .padding(.top, 25)
            .padding(.horizontal)
            
            HStack {
                HStack(spacing: -5) {
                    ForEach(caminhada.pets) { pet in
                        Image(uiImage: UIImage(data: pet.imageURL)!)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                    }
                }
                ForEach(caminhada.pets) { pet in
                    Text(pet.name)
                }
                Spacer()
            }
            .padding(.top, 15)
            .padding(.horizontal)
            
            Map {
                MapPolyline(coordinates: caminhada.decodedRoute())
                    .stroke(.blue, lineWidth: 5)
            }
            .frame(height: 250)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            HStack(spacing: 25) {
                VStack(spacing: 6) {
                    Image(systemName: "shoeprints.fill")
                        .font(.title)
                        .foregroundStyle(Color(red: 0.33, green: 0.69, blue: 0.85))
                    Text("\(Int(caminhada.distance)) metros\npercorridos")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
                VStack(spacing: 6) {
                    Image(systemName: "timer")
                        .font(.title)
                        .foregroundStyle(Color(red: 0.33, green: 0.69, blue: 0.85))
                    Text("\(formatarTempo(segundos: Int(caminhada.time))) de\nduração")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 40)
            VStack {
                Text(String(format: "%.1f", caminhada.distance / (caminhada.time/60)))
                    .font(.title.bold())
                    .foregroundStyle(Color(red: 0.33, green: 0.69, blue: 0.85))
                Text("metros\npor minuto")
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            
            Spacer()
        }
    }
    func formatarTempo(segundos: Int) -> String {
        let minutos = segundos / 60
        let segundosRestantes = segundos % 60
        return String(format: "%02d'%02d''", minutos, segundosRestantes)
    }
}

