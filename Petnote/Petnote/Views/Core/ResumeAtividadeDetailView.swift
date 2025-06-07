//
//  ResumeAtividadeDetailView.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 26/02/25.
//

import SwiftUI
import SwiftData
import Charts

enum ResumeViews {
    case hoje
    case semana
}
struct ResumeAtividadeDetailView: View {
    var jebs = [
        Pet(name: "Jeb", age: 3, imageURL: .mite, animal: "gato", gender: "macho", vacinas: [], consultas: [], remedios: [], caminhadas: [])
    ]
    var data = [
        Caminhada(title: "Passeio", distance: 200, time: 0, date: Date(), route: []),
        Caminhada(title: "Passeio", distance: 160, time: 0, date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, route: []),
        Caminhada(title: "Passeio", distance: 140, time: 0, date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!, route: []),
        Caminhada(title: "Passeio", distance: 130, time: 0, date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!, route: []),
        Caminhada(title: "Passeio", distance: 110, time: 0, date: Calendar.current.date(byAdding: .day, value: -4, to: .now)!, route: []),
        Caminhada(title: "Passeio", distance: 100, time: 0, date: Calendar.current.date(byAdding: .day, value: -5, to: .now)!, route: []),
        Caminhada(title: "Passeio", distance: 50, time: 0, date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!, route: [])
    ]
    @State var selectedView: ResumeViews = .hoje
    @StateObject var viewModel = ResumeViewModel()
    @State var fezAtividadeHoje = false
    @State var caminhadasHoje = [Caminhada]()
    @State var caminhadasNaSemana = 0
    @Query var pets: [Pet]
    var body: some View {
        NavigationStack {
            ScrollView {
                if selectedView == .hoje {
                    if !caminhadasHoje.isEmpty {
                        Spacer().frame(height: 30)
                        DoneActivityView()
                    } else {
                        Spacer().frame(height: 25)
                        UndoneActivityView()
                    }
                } else if selectedView == .semana {
                    Spacer().frame(height: 35)
                    ProgressCircle(progress: caminhadasNaSemana, circleWidth: 100, patasWidth: 77, patasHeight: 70)
                    Text("\(caminhadasNaSemana) de 7 dias em atividade")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    
                }
                
                HStack(spacing: 30) {
                    Text("Hoje")
                        .modifier(SelectableButtonStyle(isSelected: selectedView == .hoje, frameWidth: 90))
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedView = .hoje
                            }
                        }
                    Text("Semana")
                        .modifier(SelectableButtonStyle(isSelected: selectedView == .semana, frameWidth: 100))
                        .onTapGesture {
                            print("\(caminhadasNaSemana)")
                            withAnimation(.snappy) {
                                selectedView = .semana
                            }
                        }
//                    Text("Mês")
//                        .modifier(SelectableButtonStyle(isSelected: selectedView == .mes, frameWidth: 90))
//                        .onTapGesture {
//                            selectedView = .mes
//                        }
                }
                .padding(.top, 25)
                
                
                if selectedView == .hoje {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 10) {
                            ForEach(pets) { pet in
                                PetsScrollView(pet: pet)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.leading)
                    
                } else if selectedView == .semana {
                    LazyVStack(spacing: 10) {
                        ForEach(pets) { pet in
                            ChartView(pet: pet)
                        }
                    }
                    .padding(.top, 17)
                    
                }
            }
            .navigationTitle("Atividade")
        }
        .onAppear {
            Task {
                await viewModel.caminhadasDeHoje(pets: pets)
                self.caminhadasHoje = viewModel.caminhadasHoje
                await viewModel.caminhadasNaSemana(pets: pets)
                self.caminhadasNaSemana = viewModel.caminhadasNaSemana
            }
        }
    }
    
}

#Preview {
    ResumeAtividadeDetailView()
}

struct DoneActivityView: View {
    var body: some View {
        ZStack {
            Image(.patas)
                .resizable()
                .frame(width: 66, height: 59)
                .offset(x: -11, y: 0)
            Image(systemName: "circle.badge.checkmark")
                .resizable()
                .fontWeight(.regular)
                .foregroundStyle(Color(red: 0, green: 0.35, blue: 0.49), LinearGradient(colors: [Color(red: 0.73, green: 0.91, blue: 1), Color(red: 0.34, green: 0.66, blue: 0.93)], startPoint: .bottomTrailing, endPoint: .topLeading))
                .scaledToFit()
                .frame(width: 120, height: 110)
            
        }
        Text("Você já fez atividade hoje!")
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.top, 20)
    }
}
struct UndoneActivityView: View {
    var body: some View {
        Image(.saddog2)
            .resizable()
            .frame(width: 120, height: 120)
        Text("Nenhuma atividade registrada hoje!")
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.top, 15)
    }
}

struct PetsScrollView: View {
    var pet: Pet
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(uiImage: UIImage(data: pet.imageURL)!)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                Text(pet.name)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(red: 0, green: 0.35, blue: 0.49))
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "shoeprints.fill")
                        .foregroundStyle(Color(red: 0.18, green: 0.6, blue: 0.77))
                    Text("\(pet.distanciaHoje)m")
                }
                HStack {
                    Image(systemName: "timer")
                    Text("\(formatarTempo(segundos: Int(pet.tempoHoje)))")
                }
                .font(.system(size: 16))
            }
        }
        .padding(12)
        .frame(width: 180)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    func formatarTempo(segundos: Int) -> String {
        let minutos = segundos / 60
        let segundosRestantes = segundos % 60
        return String(format: "%02d'%02d''", minutos, segundosRestantes)
    }
}


struct ChartView: View {
    @StateObject var viewModel = ChartViewModel()
    var pet: Pet
    
    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Encontra o domingo mais próximo (início da semana)
        let weekday = calendar.component(.weekday, from: today) // 1 = Domingo, 7 = Sábado
        let daysToSunday = (weekday - 1) % 7 // Diferença até o domingo mais recente
        
        let lastSunday = calendar.date(byAdding: .day, value: -daysToSunday, to: today)!
        
        // Gera os 7 dias da semana atual (domingo a sábado)
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: lastSunday)! }
    }
    
    var weeklyData: [(date: Date, distance: Double)] {
        var groupedData: [Date: Double] = [:]
        let calendar = Calendar.current

        // Criamos um conjunto com os dias da semana para filtragem
        let weekDaysSet = Set(currentWeek)

        // Filtramos apenas as caminhadas dessa semana
        let filteredCaminhadas = pet.caminhadas.filter { weekDaysSet.contains(calendar.startOfDay(for: $0.date)) }

        // Agrupamos as distâncias por dia
        for caminhada in filteredCaminhadas {
            let day = calendar.startOfDay(for: caminhada.date)
            groupedData[day, default: 0] += caminhada.distance
        }
        // Retorna os valores da semana na ordem correta
        return currentWeek.map { ($0, groupedData[$0] ?? 0) }
    }
    
    var totalDistanciaSemana: Double {
        weeklyData.reduce(0) { $0 + $1.distance }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(uiImage: UIImage(data: pet.imageURL)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text(pet.name)
                    .font(.title.weight(.medium))
                    .foregroundStyle(Color(red: 0, green: 0.35, blue: 0.49))
            }
            Text("\(Int(totalDistanciaSemana)) metros")
                .font(.title.weight(.semibold))
                .foregroundStyle(Color(red: 0.18, green: 0.6, blue: 0.77))
            Chart {
                ForEach(weeklyData, id: \.date) { data in
                    BarMark(
                        x: .value("Dia", data.date, unit: .day),
                        y: .value("Distância", data.distance)
                    )
                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.51, green: 0.8, blue: 0.93), Color(red: 0, green: 0.35, blue: 0.49)], startPoint: .top, endPoint: .bottom))
                    .cornerRadius(5)
                }
            }
            .padding(.top, 5)
            .frame(height: 180)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { date in
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true) // "Dom", "Seg", etc.
                }
            }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}
