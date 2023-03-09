//
//  ContentView.swift
//  HiddenIconDemo
//
//  Created by VincentPro on 2023/3/6.
//

import SwiftUI

// MARK: - 純 SwiftUI 專案 (＊macOS 13.0 以上寫法，更簡單)
//@main
//struct HiddenIconDemoApp: App {
//
//    @State var currentNumber: String = "1"
//
//    var body: some Scene {
//
//        if #available(macOS 13.0, *) {
//            return
//                WindowGroup {
//                    ContentView()
//                }
//                MenuBarExtra(currentNumber, systemImage: "gamecontroller") {
//                    Button("Hide Desktop") {
//                        ...
//                    }
//                    Button("Show Desktop") {
//                        ...
//                    }
//                }
//        } else {
//            return
//                WindowGroup {
//                    EmptyView()
//                }
//        }
//    }
//}
//
//struct EmptyView: View {
//
//    var body: some View {
//        VStack {
//            Color.white
//        }
//        .frame(width: 300, height: 150)
//        .padding()
//    }
//}


struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel = .init()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.hideDesktop()
            }) {
                Text("Hide Desktop")
            }
            .padding(.bottom, 30)
            
            Button(action: {
                viewModel.showDesktop()
            }) {
                Text("Show Desktop")
            }
        }
        .padding()
    }
}


class ContentViewModel: ObservableObject {
    
    private let commandQueue = DispatchQueue(label: "com.example.commandQueue")
    
    
    func hideDesktop() {
        hideDesktopByExecutingCommand()
    }
    
    func showDesktop() {
        showDesktopByExecutingCommand()
    }
    
    private func hideDesktopByExecutingCommand() {
        let command = "defaults write com.apple.finder CreateDesktop -bool FALSE && killall Finder"
        executeScript(path: "/bin/sh", arguments: ["-c", command])
    }
    
    private func showDesktopByExecutingCommand() {
        let command = "defaults write com.apple.finder CreateDesktop -bool TRUE && killall Finder"
        executeScript(path: "/bin/sh", arguments: ["-c", command])
    }
    
    private func executeScript(path: String? = nil, arguments: [String]? = nil) {
        
        // MARK: ChatGPT 第二次改寫
        /* 說明：這個改寫版本使用一個專門的 DispatchQueue，當使用 executeShellCommand 函數時，
                會將要執行的指令加入到這個 DispatchQueue 裡，讓它排隊等待執行。
                由於這個 DispatchQueue 是串行的，因此同一時間只會有一個 Process 在執行，
                其他 Process 則會等待前面的 Process 執行完畢後再依序執行，
                從而避免了同時產生太多 Process 造成的效能問題。*/
        
        commandQueue.async { [weak self] in
            
            // 註：Process是一个可以执行终端命令的类，实现执行终端命令函数(From 掘金)
            let task = Process()
            
            if let path = path {
                task.launchPath = path
            }
            
            if let arguments = arguments {
                task.arguments = arguments
            }
            
            // MARK:
            task.launch()
            task.waitUntilExit()
        }
    }

}





