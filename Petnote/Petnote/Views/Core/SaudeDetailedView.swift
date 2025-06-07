//
//  SaudeDetailedView.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 10/02/25.
//

import SwiftUI
enum Views {
    case remedios
    case vacinas
    case consultas
}
struct SaudeDetailView: View {
    @State var selectedView: Views = .vacinas
    @Environment(\.presentationMode) var presentationMode
    var pet: Pet
    @State var showSheet = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 30) {
                    Text("Remédios")
                        .modifier(SelectableButtonStyle(isSelected: selectedView == .remedios))
                        .onTapGesture {
                            selectedView = .remedios
                        }
                    Text("Vacinas")
                        .modifier(SelectableButtonStyle(isSelected: selectedView == .vacinas))
                        .onTapGesture {
                            selectedView = .vacinas
                        }
                    Text("Consultas")
                        .modifier(SelectableButtonStyle(isSelected: selectedView == .consultas))
                        .onTapGesture {
                            selectedView = .consultas
                        }
                }
                .padding(.top)
                Spacer().frame(height: 15)
                ScrollView {
                    Spacer().frame(height: 30)
                    VStack(spacing: 20) {
                        Group {
                            switch selectedView {
                            case .vacinas:
                                if !pet.vacinas.isEmpty {
                                    ForEach(pet.vacinas) { vacina in
                                        NavigationLink {
                                            EditVacinaView(vacina: vacina)
                                        } label: {
                                            VacinaItemView(vacina: vacina)
                                        }
                                    }
                                } else {
                                    Text("Nenhuma vacina adicionada")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            case .consultas:
                                if !pet.consultas.isEmpty {
                                    ForEach(pet.consultas) { consulta in
                                        NavigationLink {
                                            EditConsultaView(consulta: consulta)
                                        } label: {
                                            ConsultaItemView(consulta: consulta)
                                        }
                                    }
                                } else {
                                    Text("Nenhuma consulta adicionada")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            case .remedios:
                                if !pet.remedios.isEmpty {
                                    ForEach(pet.remedios) { remedio in
                                        NavigationLink {
                                            EditRemedioView(remedio: remedio)
                                        } label: {
                                            RemedioItemView(remedio: remedio)
                                        }
                                    }
                                } else {
                                    Text("Nenhum remédio adicionado")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal, 16)
            }
            .navigationTitle("Saúde")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Esconde o botão padrão
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                    Text("Voltar")
                }
                .foregroundStyle(Color(red: 0.22, green: 0.31, blue: 0.45))
            }, trailing: Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(Color(red: 0.22, green: 0.31, blue: 0.45), in: Circle())
            }
                .sheet(isPresented: $showSheet) {
                    if selectedView == .vacinas {
                        AddVacinaView(pet: pet)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(20)
                    } else if selectedView == .consultas {
                        AddConsultaView(pet: pet)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(20)
                    } else if selectedView == .remedios {
                        AddRemedioView(pet: pet)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(20)
                    }
                })
        }
    }
}

struct SelectableButtonStyle: ViewModifier {
    var isSelected: Bool
    var frameWidth: CGFloat = 100
    func body(content: Content) -> some View {
        content
            .frame(width: frameWidth)
            .font(.system(size: 16, weight: .medium))
            .padding(.vertical, 12)
            .foregroundStyle(isSelected ? Color(.white) : Color(red: 0.22, green: 0.31, blue: 0.45))
            .background(isSelected ? Color(red: 0.18, green: 0.6, blue: 0.77) : Color(red: 0.95, green: 0.95, blue: 0.95))
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}
#Preview {
    SaudeDetailView(pet: Pet(name: "Mite", age: 1, imageURL: .mite, animal: "Gato", gender: "Macho", vacinas: [], consultas: [], remedios: [], caminhadas: []))
}
