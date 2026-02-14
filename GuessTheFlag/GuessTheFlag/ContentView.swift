//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rachael LaMassa on 2/7/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State var askedCountries: [String] = []
    
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    
    @State private var questionsAsked = 1
    
    
    // Day 23 challenge: replace the Image view used for flags with a new FlagImage() view
    func FlagImage(_ country: String) -> some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag!")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    // .titleStyle() // Day 23 challenge
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number]) // Day 23 challenge
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionsAsked < 8 {
                Button("Continue", action: askQuestion)
            } else {
                Button("Play Again!") {
                    questionsAsked = 0
                    userScore = 0
                    countries.append(contentsOf: askedCountries)
                    askQuestion()
                }
            }
        } message: {
            if questionsAsked < 8 {
                Text("Your current score is: \(userScore)/\(questionsAsked)")
            } else {
                let finalScore = Double(userScore) / Double(questionsAsked) * 100
                Text("Congratulations! You've beaten the game with a score of \(finalScore, specifier: "%.1f")%! \(userScore)/\(questionsAsked)")
            }
        }
    }
    
    func flagTapped(_ number: Int) -> () {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
            countries.remove(at: correctAnswer)
            askedCountries.append(countries[correctAnswer])
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
        }        
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked += 1
    }
    
}

// Day 23 challenge: custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

#Preview {
    ContentView()
}
