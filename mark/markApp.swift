//
//  markApp.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//

import SwiftUI

@main
struct markApp: App {
    
    @StateObject private var markState: MarkState  = MarkState()
    
    var body: some Scene {
        WindowGroup {
            ContentView(markState: markState)
                .frame(minWidth: 550, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
            
        }
        .commands{
            FileCommands(markState: markState)
            ViewCommands(markState: markState)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
    }
}
