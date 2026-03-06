//
//  ExplicitAnimations.swift
//  Animations
//
//  Created by Rachael LaMassa on 3/6/26.
//

import SwiftUI

struct ExplicitAnimations: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap me!") {
            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(Color.red)
        .foregroundStyle(Color.white)
        .clipShape(Circle())
        .rotation3DEffect(
            .degrees(animationAmount),
            axis: (x: 0.0, y: 1.0, z: 0.0))
    }
}

#Preview {
    ExplicitAnimations()
}
