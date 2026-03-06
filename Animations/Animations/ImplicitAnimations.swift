//
//  ContentView.swift
//  Animations
//
//  Created by Rachael LaMassa on 3/6/26.
//

import SwiftUI

struct ImplicitAnimations: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap me!") {
            // animationAmount += 0.5
        }
            .padding(50)
            .background(Color.red)
            .foregroundStyle(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeOut(duration: 1.0)
                            .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            .onAppear {
                animationAmount = 2
            }
    }
}

#Preview {
    ImplicitAnimations()
}
