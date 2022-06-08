//
//  Presenter.swift
//  UIKitty
//
//  Created by Rittenzore on 16.01.2022.
//

import Foundation
import PathKit
import SwiftyXML

protocol ViewOutput {
    func fileDidSet(path: String)
}

// MARK: - Init
class Presenter {
    private let panelManager = PanelManager.shared
    
    private var file: FileModel?
    
    init () { }
}

// MARK: - ViewOutput
extension Presenter: ViewOutput {
    func fileDidSet(path: String) {
        file = FileModel(path: path)
        guard let file = file else { return }
        panelManager.showSavePanel(file: file)
    }
}
