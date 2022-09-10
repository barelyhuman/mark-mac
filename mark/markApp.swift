//
//  markApp.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//
import UniformTypeIdentifiers
import Foundation
import SwiftUI

public var _appState = MarkState()

@main
struct markApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var showPreview: Bool = false
    
    var body: some Scene {
        DocumentGroup(newDocument: MarkdownFile()) { file in
            ContentView(document:file.$document, fileUrl:file.fileURL , appDelegate: appDelegate, appState: _appState)
                .frame(minWidth: 550, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
        }
        .commands{
            ViewCommands(appState: _appState)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: [])
    }
}

