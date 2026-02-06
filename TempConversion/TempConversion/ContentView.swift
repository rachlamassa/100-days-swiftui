//
//  ContentView.swift
//  TempConversion
//
//  Created by Rachael LaMassa on 2/6/26.
//

// Temperature conversion: users choose Celsius, Fahrenheit, or Kelvin.



import SwiftUI

struct ContentView: View {
    
    @FocusState private var isFocused: Bool
    
    enum TempUnit: String, CaseIterable {
        case celsius
        case fahrenheit
        case kelvin

        var label: String {
            switch self {
            case .celsius: "Celsius"
            case .fahrenheit: "Fahrenheit"
            case .kelvin: "Kelvin"
            }
        }
    }
    
    @State private var initialTemp: Double = 0
    @State private var initialMeasurement: TempUnit = .celsius
    
    @State private var newMeasurement: TempUnit = .celsius
    
    func convertTemp(_ value: Double, from current: TempUnit, to new: TempUnit) -> Double {
        let toCelsius: Double = {
            switch current {
            case .celsius:
                return value
            case .fahrenheit:
                return (value - 32.0) * (5.0 / 9.0)
            case .kelvin:
                return value - 273.15
            }
        }()

        switch new {
        case .celsius:
            return toCelsius
        case .fahrenheit:
            return toCelsius * (9.0 / 5.0) + 32.0
        case .kelvin:
            return toCelsius + 273.15
        }
    }
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section("Starting Temperature") {
                    
                    TextField("Value", value: $initialTemp, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                        
                    Picker("Measurement", selection: $initialMeasurement) {
                        ForEach(TempUnit.allCases, id: \.self) {
                            Text($0.label)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                
                Section("New Temperature") {
                    
                    let result = convertTemp(initialTemp, from: initialMeasurement, to: newMeasurement)
                    Text(result.formatted())
                    
                    Picker("Measurement", selection: $newMeasurement) {
                        ForEach(TempUnit.allCases, id: \.self) {
                            Text($0.label)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                
            }
            .navigationTitle("Temp Conversion")
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
