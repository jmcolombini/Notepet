//
//  ResumeViewModel.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 20/02/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class ResumeViewModel: ObservableObject {
    @Published var caminhadasHoje: [Caminhada] = []
    @Published var tempoTotal = 0.0
    @Published var distanciaTotal = 0.0
    @Published var consultasOrdenadas: [ConsultaDetalhada] = []
    @Published var vacinasOrdenadas: [DoseDetalhada] = []
    @Published var remediosOrdenados: [RemedioDetalhado] = []
    @Published var caminhadasNaSemana = 0
    @Published var isAuthorized: Bool = false
    
    

        func atualizarDados(pets: [Pet]) async {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.atualizarVacinas(pets: pets) }
                group.addTask { await self.atualizarConsultas(pets: pets) }
                group.addTask { await self.atualizarRemedios(pets: pets) }
                group.addTask { await self.atualizarDistancia(pets: pets) }
                group.addTask { await self.atualizarTempo(pets: pets) }
                group.addTask { await self.caminhadasNaSemana(pets: pets) }
            }
        }
    
    func atualizarVacinas(pets: [Pet]) async {
        var dosesTemp: [DoseDetalhada] = []
        
        for pet in pets {
            let vacinas = Array(pet.vacinas)
            for vacina in vacinas {
                for dose in vacina.doses {
                    if let image = UIImage(data: pet.imageURL) {
                        let doseDetalhada = DoseDetalhada(
                            nomeVacina: vacina.name,
                            dose: dose,
                            image: image,
                            lab: vacina.lab,
                            lote: vacina.lote
                        )
                        dosesTemp.append(doseDetalhada)
                    }
                }
            }
        }

        DispatchQueue.main.async {
            self.vacinasOrdenadas = dosesTemp.sorted { $0.dose.data < $1.dose.data }
        }
    }
    
    func atualizarConsultas(pets: [Pet]) async {
        var consultas: [ConsultaDetalhada] = []
        
        for pet in pets {
            for consulta in pet.consultas {
                if let image = UIImage(data: pet.imageURL) {
                    let consultaDetalhada = ConsultaDetalhada(title: consulta.title, data: consulta.data, location: consulta.location, image: image)
                    consultas.append(consultaDetalhada)
                }
            }
        }
        DispatchQueue.main.async {
            self.consultasOrdenadas = consultas.sorted { $0.data < $1.data }
        }
    }
    
    func atualizarRemedios(pets: [Pet]) async {
        var remedios: [RemedioDetalhado] = []
        for pet in pets {
            for remedio in pet.remedios {
                if let image = UIImage(data: pet.imageURL) {
                    let remedioDetalhado = RemedioDetalhado(name: remedio.name, dose: remedio.dose, startDate: remedio.startDate, endDate: remedio.endDate, image: image)
                    remedios.append(remedioDetalhado)
                }
            }
        }
        DispatchQueue.main.async {
            self.remediosOrdenados =  remedios.sorted { $0.startDate < $1.startDate }
        }
    }
    
    func atualizarDistancia(pets: [Pet]) async {
        var distancia: Double = 0.0
        
        for pet in pets {
            for caminhada in pet.caminhadas {
                distancia = distancia + caminhada.distance
            }
        }
        DispatchQueue.main.async {
            self.distanciaTotal = distancia
        }
    }
    
    func atualizarTempo(pets: [Pet]) async {
        var tempo: TimeInterval = 0.0
        
        for pet in pets {
            for caminhada in pet.caminhadas {
                tempo = tempo + caminhada.time
            }
        }
        DispatchQueue.main.async {
            self.tempoTotal = tempo
        }
    }
    func caminhadasDeHoje(pets: [Pet]) async  {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        var caminhadasHoje: [Caminhada] = []

        for pet in pets {
            let caminhadasDoPetHoje = pet.caminhadas.filter { caminhada in
                let caminhadaDate = calendar.startOfDay(for: caminhada.date)
                return caminhadaDate == today
            }
            caminhadasHoje.append(contentsOf: caminhadasDoPetHoje)
        }
        DispatchQueue.main.async {
            self.caminhadasHoje = caminhadasHoje
        }
    }
    
    func distanciaPercorridaHoje(pets: [Pet]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for pet in pets {
            let distanciaTotal = pet.caminhadas
                .filter { calendar.startOfDay(for: $0.date) == today }
                .reduce(0) { $0 + $1.distance }
            pet.distanciaHoje += Int(distanciaTotal)
        }
    }
    
    func tempoPercorridoHoje(pets: [Pet]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for pet in pets {
            let tempo = pet.caminhadas
                .filter { calendar.startOfDay(for: $0.date) == today }
                .reduce(0) { $0 + $1.time }
            pet.tempoHoje += tempo
        }
    }
    
    func caminhadasNaSemana(pets: [Pet]) async {
        let calendar = Calendar.current
        let today = Date()

        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        let diasComCaminhadas = Set(pets.flatMap { pet in
            pet.caminhadas
                .filter { caminhada in
                    let dataCaminhada = calendar.startOfDay(for: caminhada.date)
                    return dataCaminhada >= startOfWeek && dataCaminhada <= endOfWeek
                }
                .map { calendar.startOfDay(for: $0.date) }
        }).count
        
        DispatchQueue.main.async {
            self.caminhadasNaSemana = diasComCaminhadas
        }
    }
}
