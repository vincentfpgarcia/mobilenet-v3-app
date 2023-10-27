//
//  CyberpunkView.swift
//  mobilenet-v3-app
//
//  Created by Vincent Garcia on 10/1/23.
//

import SwiftUI

let radius: CGFloat = 15
let spacing: CGFloat = 20

extension Color {
    static let cyberpunkBackground = Color(red: 0.94, green: 0.00, blue: 1.00) // Violet
    static let cyberpunkText = Color(red: 1.00, green: 0.91, blue: 0.00) // Yellow
    static let cyberpunkCaption = Color.white
}

struct ImageView: View {

    @ObservedObject var engine: Engine

    var body: some View {
        if let image = engine.viewfinderImage {
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(radius)
        }
    }
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

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .textCase(.uppercase)
            .foregroundColor(Color.cyberpunkCaption)
    }
}

struct ValueModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.black)
            .textCase(.uppercase)
            .foregroundColor(Color.cyberpunkText)
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
                    .modifier(TitleModifier())
                Text(label)
                    .modifier(ValueModifier())
            }

            HStack(spacing: 0) {
                let proba =  "\(Int((engine.probability ?? 0) * 100)) %"
                VStack {
                    Text("Confidence")
                        .modifier(TitleModifier())
                    Text(proba)
                        .modifier(ValueModifier())
                }
                .frame(width: width / 2.0)

                let fps = "\(engine.fps ?? 0)"
                VStack {
                    Text("FPS")
                        .modifier(TitleModifier())
                    Text(fps)
                        .modifier(ValueModifier())
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
