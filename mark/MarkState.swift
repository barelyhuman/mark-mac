//
//  MarkState.swift
//  mark
//
//  Created by Reaper Gelera on 09/09/22.
//
import SwiftUI

// Shared Observable object to share state
// between this content view and the main
// app
public class MarkState: ObservableObject {
    @Published var preview: Bool = false
    @Published var filename: String = "Untitled.md"
    @Published var filePath: String = ""
    @Published var content: String = ""
    @Published var savePath: String = ""
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    
    func showToast(message:String) {
        self.showToast = true
        self.toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showToast = false
            self.toastMessage = ""
        }
        
        
    }
    
    func togglePreview(){
        withAnimation{
            self.preview = !self.preview
        }
    }
    
    func updateContent(content:String){
        self.content = content
    }
    
    func setFileName(url:String, name:String){
        self.filename = name
        self.filePath = url
    }
    
    func openFile(fileurl:URL){
        do {
            self.filePath = fileurl.path
            self.savePath = fileurl.path
            self.filename = fileurl.lastPathComponent
            self.content = try String(contentsOf: fileurl, encoding: .utf8)
        }catch{
            print(error)
        }
    }
    
    func triggerOpenDialog(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            if let fileurl = panel.url {
                self.openFile(fileurl:fileurl)
            }
        }
    }
    
    func triggerSaveDialog(onComplete: (()->Void)? = nil){
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = self.filename
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let savePath = savePanel.url?.path {
                    self.savePath = savePath
                    savePanel.close()
                    onComplete?()
                }
                
            }
        }
    }
    
    func triggerSaveFileAs(){
        self.triggerSaveDialog(){
            if(self.savePath.isEmpty){
                return
            }
            
            self.writeFileToSavePath()
        }
    }
    
    func triggerSaveFile(){
        if self.savePath.isEmpty {
            self.triggerSaveDialog(){
                if(self.savePath.isEmpty){
                    return
                }
                self.writeFileToSavePath()
            }
        }
        self.writeFileToSavePath()
    }
    
    func writeFileToSavePath() {
        do {
            try self.content.write(to: URL(fileURLWithPath: savePath), atomically: true, encoding: .utf8)
            self.showToast(message:"File Saved")
        }catch{
            print(error)
        }
    }
    
    
}
