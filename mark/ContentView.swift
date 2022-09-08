//
//  ContentView.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//

import SwiftUI
import MarkdownUI
import HighlightedTextEditor
import SimpleToast

// add another transition to the
// AnyTransition class to allow
// moving to and from the same edge
extension AnyTransition {
    static var sameEdgeSlide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .trailing))}
}


// clear the textview background to align it with the
// current background color
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
        
    }
}

var defaultText:String = """
You can type in markdown here
"""

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
    
    func triggerOpenDialog(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            self.filePath = panel.url?.path ?? ""
            self.savePath = panel.url?.path ?? ""
            self.filename = panel.url?.lastPathComponent ?? ""
            do {
                if let fileurl = panel.url {
                    self.content = try String(contentsOf: fileurl, encoding: .utf8)
                    panel.close()
                }
            }catch{
                print(error)
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



struct ContentView: View {
    @StateObject var markState: MarkState
    @State var filename = "Untitled.md"
    @State var input: String = ""
    
    // duplicated local state to make sure the animation timing
    // syncs with the one from the above observable
    @State private var localPreview: Bool = false
    
    
    private let accentColor = Color.init(red: 247.0, green: 110.0, blue: 201.0, opacity: 1.0)
    
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 2.5
    )
    
    
    var body: some View {
        // overall horizontal split stack
        HStack(alignment:.top,spacing: 0) {
            VStack
            {
                TextEditor(
                    text: $input
                )
                    .font(Font.custom("Hermit", size: 13.5))
                    .padding(10)
                    .onChange(of: input) { newValue in
                        markState.updateContent(content: newValue)
                    }
                    .onReceive(markState.$content){(val) in
                        if val == input {return}
                        input = val
                        return
                    }
                //TODO: add in options to select font in settings
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            if localPreview {
                ScrollView{
                    VStack {
                        Markdown(
                            markState.content
                        ).markdownStyle(
                            MarkdownStyle(
                                font: .custom("Hermit", size: 13.5),
                                measurements: .init(
                                    codeFontScale: 0.95,
                                    headingSpacing: 0.5
                                )
                            )
                        )
                            .padding(10)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .transition(.sameEdgeSlide)
            }
        }
        .onReceive(markState.$preview){ (val) in
            localPreview = val
        }
        .simpleToast(isPresented: $markState.showToast, options: toastOptions) {
            HStack {
                HStack{
                    Text(markState.toastMessage)
                        .padding(.top,8)
                        .padding(.bottom,8)
                        .padding(.leading,12)
                        .padding(.trailing,12)
                }
                .background(Color("Accent"))
                .foregroundColor(Color.black)
                .cornerRadius(6)
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .toolbar(){
            ToolbarItem {
                Spacer()
            }
            ToolbarItem {
                Button("Toggle Preview") {
                    markState.togglePreview()
                }
            }
        }
    }
}

