//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Rachael LaMassa on 2/22/26.
//

import SwiftUI

struct ContentView: View {
    
    enum GameMove: String, CaseIterable {
        case rock, paper, scissors
        
        var labelImage: String {
            switch self {
            case .rock: return "mountain.2"
            case .paper: return "newspaper"
            case .scissors: return "scissors"
            }
        }
        
        var winningMove: GameMove? {
            switch self {
            case .rock: return .scissors
            case .paper: return .rock
            case .scissors: return .paper
            }
        }
        
        var losingMove: GameMove? {
            switch self {
            case .rock: return .paper
            case .paper: return .scissors
            case .scissors: return .rock
            }
        }
        
        static func random() -> GameMove {
            Self.allCases.randomElement()!
        }
    }
    
    @State private var cpuMove = GameMove.random()
    @State private var willWin = Bool.random()
    
    @State private var score: Int = 0
    @State private var questionsAsked: Int = 0
    
    @State private var showingAlert: Bool = false
    
    private func makeMove(using user: GameMove, for cpu: GameMove, to result: Bool) -> Bool {
        
        if result {
            return user == cpu.losingMove
        } else {
            return user == cpu.winningMove
        }
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .blue, .indigo]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                
                Text("Rock! Paper! Scissors!")
                    .font(.title.bold())
                
                Text("How will you \(willWin ? "win" : "lose") against \(Image(systemName: "\(cpuMove.labelImage)"))?")
                    .font(.headline)
                    
                    
                HStack() {
                    ForEach(GameMove.allCases, id: \.self) { move in
                            Button {
                                let result: Bool = makeMove(using: move, for: cpuMove, to: willWin)
                                    
                                if result {
                                    score += 1
                                } else if result == false && score > 0 {
                                    score -= 1
                                }
                                    
                                cpuMove = .random()
                                willWin = Bool.random()
                                questionsAsked += 1
                                    
                                if questionsAsked == 10 {
                                    showingAlert = true
                                }
                                    
                            } label: {
                                Image(systemName: "\(move.labelImage)")
                                    .font(.title)
                            }
                    .frame(maxWidth: .infinity)
                    }
                }
                
                
                Text("Your score: \(score)")
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.6))
            .padding(.vertical, 50)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding(.horizontal)
            .shadow(radius: 20)
        }
        .alert("Game Over", isPresented: $showingAlert) {
            Button("Play Again") {
                score = 0
                questionsAsked = 0
                cpuMove = .random()
                willWin = Bool.random()
            }
        } message: {
            Text("You scored \(score) out of 10!")
        }
    }
}

#Preview {
    ContentView()
}
