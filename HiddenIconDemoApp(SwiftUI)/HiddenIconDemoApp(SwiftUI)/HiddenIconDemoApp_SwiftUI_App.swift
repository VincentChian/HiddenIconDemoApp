//
//  HiddenIconDemoApp_SwiftUI_App.swift
//  HiddenIconDemoApp(SwiftUI)
//
//  Created by VincentPro on 2023/3/9.
//

import SwiftUI

@main
struct HiddenIconDemoApp: App {
    
    @State var currentNumber: String = "1"
    @StateObject var viewModel: ContentViewModel = .init()
    
    var body: some Scene {
        
        if #available(macOS 13.0, *) {
            return
            MenuBarExtra(currentNumber, systemImage: "gamecontroller") {
                Button("Hide Desktop") {
                    viewModel.hideDesktop()
                }
                Button("Show Desktop") {
                    viewModel.showDesktop()
                }
            }
        } else {
            return
            WindowGroup {
                EmptyView()
            }
        }
    }
}

struct EmptyView: View {

    var body: some View {
        VStack {
            Color.white
        }
        .frame(width: 300, height: 150)
        .padding()
    }
}
