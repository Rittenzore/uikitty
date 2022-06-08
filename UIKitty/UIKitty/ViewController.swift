//
//  ViewController.swift
//  UIKitty
//
//  Created by Rittenzore on 30.10.2021.
//

import Cocoa
import ADragDropView
import SwiftyXML

enum ViewType {
    case storyboard
    case xib
}

class ViewController: NSViewController {
    
    var presenter: ViewOutput?

    // MARK: - UI properties
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var dragNDropView: ADragDropView!
    @IBOutlet var backgroundview: NSView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Presenter()
                
        backgroundview.window?.backgroundColor = .white
        
        dragNDropView.delegate = self
        dragNDropView.acceptedFileExtensions = ["storyboard", "xib"]
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

// MARK: - Private methods
private extension ViewController {
    
}

// MARK: - ADragDropViewDelegate
extension ViewController: ADragDropViewDelegate {
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL URL: URL) {
        let urlString = String(describing: URL).replacingOccurrences(of: "file://", with: "")
        presenter?.fileDidSet(path: urlString)
    }
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFilesWithURLs URLs: [URL]) {
        
    }
}
