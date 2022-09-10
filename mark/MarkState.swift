//
//  MarkState.swift
//  mark
//
//  Created by Reaper Gelera on 10/09/22.
//

import Foundation
import SwiftUI


public class MarkState: ObservableObject {
    @Published var preview: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMsg: String = "File Saved"
    
    func togglePreview(){
        withAnimation{
            self.preview = !self.preview
        }
    }
    
    func showToast(message:String) {
        self.showToast = true
        self.toastMsg = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showToast = false
            self.toastMsg = ""
        }
    }
}
