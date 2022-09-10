//
//  MarkdownFile.swift
//  mark
//
//  Created by Reaper Gelera on 10/09/22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI


struct MarkdownFile: FileDocument {
    // tell the system we support only plain text
    
    static var readableContentTypes = [UTType.plainText, UTType.text]
    
    
    // by default our document is empty
    var text = ""
    var name = ""
    
    init(initialText: String = "",initialName:String = "untitled.md") {
        text = initialText
        name = initialName
    }

    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        if let data = configuration.file.filename {
            name = data
        }else{
            throw CocoaError(.fileReadCorruptFile)
        }
        
        configuration.file.filename = name
        configuration.file.preferredFilename = name
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        let fw = FileWrapper(regularFileWithContents: data)
        fw.preferredFilename = name
        fw.filename = name
        
        print("file saved")
        
        _appState.showToast(message: "File saved")
        
        return fw
    }
}
