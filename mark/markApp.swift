//
//  markApp.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//

import Foundation
import SwiftUI

@main
struct markApp: App {
    @StateObject private var markState: MarkState  = MarkState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(markState: markState, appDelegate:appDelegate)
                .frame(minWidth: 550, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
        }
        .commands{
            FileCommands(markState: markState)
            ViewCommands(markState: markState)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: [])
        
    }
}

