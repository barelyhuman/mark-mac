//
//  Commands.swift
//  mark
//
//  Created by Reaper Gelera on 29/08/22.
//

import SwiftUI

struct ViewCommands: Commands {
    @StateObject var previewModel: PreviewModel
    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Toggle Preview") {
                previewModel.toggle()
            }.keyboardShortcut("k",modifiers: [.command])
            }
    }
}
