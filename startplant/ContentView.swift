//
//  ContentView.swift
//  smartplant
//
//  Created by Silvia Lembo on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var dropPosition = CGFloat(-900)  // Posizione iniziale della goccia (più in alto)
    @State private var showSpray = false             // Indica se mostrare la spruzzata
    @State private var sprayPositions: [CGFloat] = [] // Posizioni per le gocce della spruzzata

    let sprayCount = 10 // Numero di gocce nella spruzzata
    let waterLevel: CGFloat = 500 // Posizione del livello dell'acqua (dove la goccia cade)

    var body: some View {
        VStack {
            Spacer() // Distanza sopra la goccia
            ZStack {
                // Goccia d'acqua (un cerchio)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .offset(y: dropPosition) // Posizione Y della goccia
                    .animation(.easeIn(duration: 1), value: dropPosition) // Animazione per la caduta
                    .onAppear {
                        // Quando la vista appare, fa partire la caduta della goccia
                        dropPosition = waterLevel // Goccia parte da più in alto e arriva al livello dell'acqua
                    }

                // Se la goccia ha toccato il livello dell'acqua, mostra la spruzzata
                if showSpray {
                    ForEach(0..<sprayCount, id: \.self) { index in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .offset(y: sprayPositions[index])
                            .offset(x: CGFloat.random(in: -30...30)) // Disperde le gocce a caso
                            .animation(
                                .easeOut(duration: 0.6)
                                    .delay(Double(index) * 0.1), value: sprayPositions[index]
                            )
                    }
                }
            }
        }
        .onAppear {
            // Inizia la caduta della goccia automaticamente quando la vista appare
            withAnimation(.easeIn(duration: 1)) {
                dropPosition = waterLevel // La goccia cade fino al livello dell'acqua
            }
            
            // Dopo che la goccia ha toccato l'acqua, mostra la spruzzata
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showSpray = true
                sprayPositions = Array(repeating: waterLevel, count: sprayCount)
                for i in 0..<sprayCount {
                    sprayPositions[i] = CGFloat.random(in: waterLevel - 50...waterLevel + 50) // Posizioni casuali per la spruzzata
                }
            }
        }
        .edgesIgnoringSafeArea(.top) // Per permettere alla goccia di cadere fuori dallo schermo
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
