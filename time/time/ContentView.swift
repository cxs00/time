//
//  ContentView.swift
//  time
//
//  番茄时钟主视图
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PomodoroWebView()
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
