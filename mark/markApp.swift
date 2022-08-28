//
//  markApp.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//

import SwiftUI

@main
struct markApp: App {
    
    @StateObject private var previewModel: PreviewModel  = PreviewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(previewModel: previewModel)
                .frame(minWidth: 550, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
            
        }
        .commands{
            ViewCommands(previewModel: previewModel)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
    }
}
