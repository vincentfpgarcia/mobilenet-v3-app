//
//  IntroView.swift
//  mobilenet-v3-app
//
//  Created by Vincent Garcia on 9/12/23.
//

import SwiftUI

//let page0 = "You are using a demo app used to showcase ML models inference running locally on device."

let page0 = "You are using a demo app used to showcase how easy it is to integrate a ML model in an app that can run locally on your Apple device"

let page1 = "The app uses the MobileNet model to analyze in real time what the camera captures"

let page2 = "The app displays the model's prediction, the confidence and the number of model inferences performed per second"

let page3 = "No AI/ML expertise is needed to integrate and use such a model as it only requires 3 lines of code"

let page4 = "The inference runs locally on your device which means no cloud GPU cost, no scalability issues, no security issues"


struct TextIntro: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2).multilineTextAlignment(.center)
    }
}

extension View {
    func introStyle() -> some View {
        modifier(TextIntro())
    }
}

struct IntroView: View {

    @Environment(\.dismiss) var dismiss
    @State private var activeTab : Int = 0

    var body: some View {
        GeometryReader { geo in
            VStack {

                GeometryReader { _ in
                    TabView(selection: $activeTab) {
                        Text(page0).introStyle().tag(0)
                        Text(page1).introStyle().tag(1)
                        Text(page2).introStyle().tag(2)
                        Text(page3).introStyle().tag(3)
                        Text(page4).introStyle().tag(4)
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }

                Button(action: close) {
                    Text("Start using the app")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding()

        }
    }

    func close() {
        dismiss()
        print("Coucou")
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
