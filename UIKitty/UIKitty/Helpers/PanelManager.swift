//
//  PanelManager.swift
//  UIKitty
//
//  Created by Rittenzore on 17.01.2022.
//

import Foundation
import Cocoa

class PanelManager {
    var saveProjectPathURL: URL?
    
    static let shared = PanelManager()
    
    private init() { }
    
    func showSavePanel(file: FileModel) {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = true
        savePanel.allowedFileTypes = ["swift"]
        savePanel.allowsOtherFileTypes = false
        savePanel.nameFieldStringValue = file.fileName
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let filename = savePanel.url
                do {
                    try file.generatedContent.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                } catch let error {
                    print("error: \(error)")
                }
            }
        }
    }
}
