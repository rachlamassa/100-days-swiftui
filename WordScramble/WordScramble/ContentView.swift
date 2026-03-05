//
//  ContentView.swift
//  WordScramble
//
//  Created by Rachael LaMassa on 2/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords: [String] = []
    @State private var rootWord: String = ""
    @State private var newWord: String = ""
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingError: Bool = false
    @State private var score: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)
                    }
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                }
                
                // Day 31 Challenge: track and show the player’s score for a given root word
                Text("Score: \(score)")
                    .font(.largeTitle.bold())
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Okay") {}
            } message: {
                Text(errorMessage)
            }
            // Day 31 Challenge: add a toolbar button that calls startGame()
            .toolbar {
                Button("Start new game") {
                    startGame()
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Day 31 Challenge: disallow answers that are shorter than three letters
        guard answer.count >= 3 else {
            wordError(title: "Word is too short.", message: "Think again!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used.", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible.", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized.", message: "You can't make it up!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        score += newWord.count
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.split(separator: "\n")
                rootWord = String(allWords.randomElement() ?? "silkworm")
                return
            }
        }
        
        usedWords.removeAll()
        score = 0
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    // Day 31 Challenge: disallow answers that are our start word
    func isOriginal(word: String) -> Bool {
        if word == rootWord { return false }
        
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorMessage = message
        errorTitle = title
        showingError.toggle()
    }
}

#Preview {
    ContentView()
}
