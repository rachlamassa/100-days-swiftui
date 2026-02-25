//
//  ContentView.swift
//  BetterRest
//
//  Created by Rachael LaMassa on 2/23/26.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert: Bool = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    private var prediction: Date? {
        do {
            let config = MLModelConfiguration()
            let model = try BetterRest(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )

            return wakeUp - prediction.actualSleep
        } catch {
            return nil
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section { // VStack(alignment: .leading, spacing: 0)
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter as time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section { // VStack(alignment: .leading, spacing: 0)
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section { // VStack(alignment: .leading, spacing: 0)
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    // Stepper("^[\(coffeeAmount) cup](inflect:true)", value: $coffeeAmount, in: 1...20)
                    
                    Picker("^[\(coffeeAmount) cup](inflect:true)", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { amount in
                            Text("\(amount)")
                                .tag(amount)
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    Text("Your ideal bedtime is...")
                        .font(.title)
                    if let prediction {
                        Text(prediction.formatted(date: .omitted, time: .shortened))
                            .font(.largeTitle.bold())
                    } else {
                        Text("Unable to calculate your bedtime. Try again.")
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.largeTitle)
                .listRowBackground(Color.clear)
                
                
            }
            .navigationTitle(Text("BetterRest"))
            .toolbar {
                // Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Okay") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try BetterRest(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "There was a problem calculating your bedtime."
        }
        
        
        showingAlert = true
    }
}

#Preview {
    ContentView()
}

