//
//  Custom.swift
//  Animations
//
//  Created by Rachael LaMassa on 3/6/26.
//

import SwiftUI

struct CustomBindings: View {
    @State private var animationAmount = 1.0
    var body: some View {
        print(animationAmount)
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1).repeatCount(3, autoreverses: true)
                ), in: 1...10)
                Spacer()
                
                Button("Tap me") { animationAmount += 1 }
                    .padding(40)
                    .background(Color.red)
                    .foregroundStyle(Color.white)
                    .clipShape(Circle())
                .scaleEffect(animationAmount)
        }
    }
}

#Preview {
    CustomBindings()
}
