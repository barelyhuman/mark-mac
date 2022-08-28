//
//  ContentView.swift
//  mark
//
//  Created by Reaper Gelera on 28/08/22.
//

import SwiftUI
import MarkdownUI
import HighlightedTextEditor

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
public class PreviewModel: ObservableObject {
    @Published var preview: Bool = false
    
    func toggle(){
        withAnimation{
            self.preview = !self.preview
        }
    }
}



struct ContentView: View {
    @State private var fullText: String = defaultText
    @StateObject var previewModel: PreviewModel
    
    // duplicated local state to make sure the animation timing
    // syncs with the one from the above observable
    @State private var localPreview: Bool = false
    
    
    var body: some View {
        // overall horizontal split stack
        HStack(alignment:.top,spacing: 0) {
            VStack
            {
                TextEditor(
                    text: $fullText)
                    .font(Font.custom("Hermit", size: 13.5))
                    .padding(10)
                //TODO: add in options to select font in settings
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            
            if localPreview {
                ScrollView{
                    VStack {
                        Markdown(
                            fullText
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
        .onReceive(previewModel.$preview){ (val) in
            localPreview = val
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .toolbar(){
            ToolbarItem {
                Spacer()
            }
            ToolbarItem {
                Button("Toggle Preview") {
                    previewModel.toggle()
                }
            }
        }
    }
}

