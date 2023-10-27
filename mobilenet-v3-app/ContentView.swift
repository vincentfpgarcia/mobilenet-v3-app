//
//  ContentView.swift
//  mobilenet-v3-app
//
//  Created by Vincent Garcia on 9/11/23.
//

import SwiftUI


struct ContentView: View {

    @StateObject private var engine = Engine()

    @State private var showSheet = false

    var body: some View {

        CyberpunkView(engine: engine)
        .sheet(isPresented: $showSheet) {
            IntroView()
        }
        .task {
            await engine.camera.start()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
