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
    @Binding var document: MarkdownFile
    var fileUrl: URL?
    @StateObject var appDelegate: AppDelegate
    @StateObject var appState: MarkState


    private let toastOptions = SimpleToastOptions(
        alignment: .bottomTrailing,
        hideAfter: 2.5
    )
    
    
    var body: some View {
        VStack {
            if let data = fileUrl?.lastPathComponent {
                Text(data).foregroundColor(Color("Subtle"))
                    .padding()
                    .padding(.bottom,2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(alignment:.top,spacing: 0) {
                VStack
                {
                    
                    TextEditor(
                        text: $document.text
                    )
                        .font(Font.custom("Hermit", size: 13.5))
                        .padding(10)
                }
                .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
                
                
                if appState.preview {
                    ScrollView{
                        VStack {
                            Markdown(
                                document.text
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
        }
        .simpleToast(isPresented: $appState.showToast, options: toastOptions) {
            HStack {
                HStack{
                    Text(appState.toastMsg)
                        .padding(.top,8)
                        .padding(.bottom,8)
                        .padding(.leading,12)
                        .padding(.trailing,12)
                }
                .background(Color("Accent"))
                .foregroundColor(Color("OnAccent"))
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
                    appState.togglePreview()
                }
            }
        }
    }
}

