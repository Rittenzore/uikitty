//
//  ContentViewModel.swift
//  UIKitty
//
//  Created by Rittenzore on 20.04.2022.
//

import Foundation

struct ContentViewModel {
    var elementType: ElementType
    var elementId: String
    
    var safeAreaId: String?
    
    var contentViewTypeString: String {
        switch elementType {
        case .tableView: return ""
        case .tableViewCell: return "contentView"
        case .imageView: return ""
        case .label: return ""
        case .button: return ""
        case .view: return ""
        case .textField: return ""
        case .collectionView: return ""
        case .collectionViewCell: return ""
        case .stackView: return ""
        case .viewController: return "view"
        }
    }
}
