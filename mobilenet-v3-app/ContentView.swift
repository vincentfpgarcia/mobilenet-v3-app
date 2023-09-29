//
//  ContentView.swift
//  mobilenet-v3-app
//
//  Created by Vincent Garcia on 9/11/23.
//

import SwiftUI

fileprivate let radius = CGFloat(15)

struct ContentView: View {

    @StateObject private var engine = Engine()

    @State private var showSheet = true

    var body: some View {

        ZStack {

            BackgroundView(engine: engine)

            VStack(spacing: 20) {
                ImageView(engine: engine)
                InfoView(engine: engine)
            }
            .padding()
        }
        .sheet(isPresented: $showSheet) {
            IntroView()
        }
        .task {
            await engine.camera.start()
        }
    }
}


struct BackgroundView: View {
    @ObservedObject var engine: Engine
    var body: some View {
        GeometryReader { geo in
//            let (red, green, blue) = computeColor()
//            Color(red: red, green: green, blue: blue)
            Color(white: 0.95)
        }
        .ignoresSafeArea()
    }

    func computeColor() -> Color {
        guard let probability = engine.probability else {
            return Color(red: 0.8, green: 0.8, blue: 0.8)
        }

        if probability < 0.2 {
            return Color(red: 1.0, green: 0.8, blue: 0.8)
        }

        if probability < 0.4 {
            return Color(red: 1.0, green: 1.0, blue: 0.8)
        }

        return Color(red: 0.8, green: 1.0, blue: 0.8)
    }
}


struct BackgroundView2: View {
    @ObservedObject var engine: Engine
    var body: some View {

        GeometryReader { geo in
            if let cgImage = engine.cgImage {
                Image(uiImage: UIImage(cgImage: cgImage))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: 10)
                    .overlay() {
                        Color.black.opacity(0.5).ignoresSafeArea()
                    }
            }
        }
    }
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


struct InfoView: View {

    @ObservedObject var engine: Engine

    var body: some View {

        VStack(spacing: 10) {

            let label = engine.label != nil ? engine.label! : "Undefined"
            HStack {
                Text("What")
                Spacer()
                Text(label)
            }

            let proba =  "\(engine.probability != nil ? Int(engine.probability! * 100) : 0) %"
            HStack {
                Text("Confidence")
                Spacer()
                Text(proba)
            }

            let fps = engine.fps != nil ? engine.fps! : 0
            HStack {
                Text("Inferences per second")
                Spacer()
                Text("\(fps)")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(radius)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
