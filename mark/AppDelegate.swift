//
//  AppDelegate.swift
//  mark
//
//  Created by Reaper Gelera on 09/09/22.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate,ObservableObject {
    @Published var fileToOpen = ""
    func application(_ application: NSApplication, open urls: [URL]) {
        if urls.isEmpty {
            return
        }
        self.fileToOpen = urls[0].path
    }
}
