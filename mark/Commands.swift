//
//  Commands.swift
//  mark
//
//  Created by Reaper Gelera on 29/08/22.
//

import SwiftUI

struct ViewCommands: Commands {
    @StateObject var appState: MarkState
    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Toggle Preview") {
                appState.togglePreview()
            }.keyboardShortcut("k",modifiers: [.command])
        }
    }
}
