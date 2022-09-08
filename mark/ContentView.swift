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



struct ContentView: View {
    @StateObject var markState: MarkState
    @State var filename = "Untitled.md"
    @State var input: String = ""
    @StateObject var appDelegate: AppDelegate
    
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
                    .onReceive(appDelegate.$fileToOpen){(val) in
                        if val.isEmpty
                        {return }
                        let url = URL(fileURLWithPath: val)
                        markState.openFile(fileurl: url)
                        return
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

