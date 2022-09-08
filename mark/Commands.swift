//
//  Commands.swift
//  mark
//
//  Created by Reaper Gelera on 29/08/22.
//

import SwiftUI

struct ViewCommands: Commands {
    @StateObject var markState: MarkState
    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Toggle Preview") {
                markState.togglePreview()
            }.keyboardShortcut("k",modifiers: [.command])
        }
    }
}

struct FileCommands: Commands {
    @StateObject var markState: MarkState
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Open File") {
                markState.triggerOpenDialog()
            }.keyboardShortcut("o",modifiers: [.command])
            
            Button("Save File"){
                markState.triggerSaveFile()
            }.keyboardShortcut("s",modifiers: [.command])
            
            Button("Save File As"){
                markState.triggerSaveFileAs()
            }.keyboardShortcut("s",modifiers: [.command,.shift])
            
        }
    }
}
