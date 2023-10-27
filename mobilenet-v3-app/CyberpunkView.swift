//
//  CyberpunkView.swift
//  mobilenet-v3-app
//
//  Created by Vincent Garcia on 10/1/23.
//

import SwiftUI

let spacing: CGFloat = 20

extension Color {
//    static let cyberpunkBackground = Color(red: 0.96, green: 0.49, blue: 0.65)
    static let cyberpunkBackground = Color(red: 0.94, green: 0.00, blue: 1.00) // Violet
//    static let cyberpunkBackground = Color(red: 1.00, green: 0.91, blue: 0.00) // Yellow
//    static let cyberpunkBackground = Color(red: 0.03, green: 0.82, blue: 0.92)
//    static let cyberpunkText = Color(red: 0.97, green: 0.91, blue: 0.19)
    static let cyberpunkText = Color(red: 1.00, green: 0.91, blue: 0.00) // Yellow
//    static let cyberpunkText = Color(red: 0.30, green: 0.93, blue: 0.92)
    static let cyberpunkCaption = Color.white
}


struct CyberpunkView: View {
    @State var engine: Engine
    var body: some View {
        GeometryReader { geo in
            ZStack {
                CyberpunkBackgroundView()

                VStack(spacing: spacing) {
                    ImageView(engine: engine).padding()
                    CyberpunkInfoView(engine: engine, width: geo.size.width)
                }
            }
        }
    }
}


struct CyberpunkBackgroundView: View {
    var body: some View {
        Color.cyberpunkBackground
            .ignoresSafeArea()
    }
}


struct CyberpunkInfoView: View {
    @ObservedObject var engine: Engine
    @State var width: CGFloat
    var body: some View {

        VStack(spacing: spacing) {

            VStack {
                let label = engine.label ?? "Undefined"
                Text("What")
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(Color.cyberpunkCaption)
                Text(label)
                    .font(.title)
                    .fontWeight(.black)
                    .textCase(.uppercase)
                    .foregroundColor(Color.cyberpunkText)
            }

            HStack(spacing: 0) {
                let proba =  "\(engine.probability != nil ? Int(engine.probability! * 100) : 0) %"
                VStack {
                    Text("Confidence")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(Color.cyberpunkCaption)
                    Text(proba)
                        .font(.title)
                        .fontWeight(.black)
                        .textCase(.uppercase)
                        .foregroundColor(Color.cyberpunkText)
                }
                .frame(width: width / 2.0)

                let fps = engine.fps ?? 0
                VStack {
                    Text("FPS")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(Color.cyberpunkCaption)
                    Text("\(fps)")
                        .font(.title)
                        .fontWeight(.black)
                        .textCase(.uppercase)
                        .foregroundColor(Color.cyberpunkText)
                }
                .frame(width: width / 2.0)

            }
        }
    }
}


struct CyberpunkView_Previews: PreviewProvider {
    static var previews: some View {
        CyberpunkView(engine: Engine())
    }
}
