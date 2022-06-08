//
//  ElementType.swift
//  UIKitty
//
//  Created by Rittenzore on 13.01.2022.
//

import Foundation

enum StackViewAxis {
    case vertical
    case horizontal
}

enum ElementType: String, CaseIterable {
    case tableView
    case tableViewCell
    case imageView
    case label
    case button
    case view
//    case segmentedControl
//    case switchControl = "switch"
    case textField
//    case textView
//    case activityIndicatorView
//    case pageControl
    case collectionView
    case collectionViewCell
    case stackView
    case viewController
    
    var elementTypeName: String {
        switch self {
        case .tableView:            return "UITableView"
        case .tableViewCell:        return "UITableViewCell"
        case .imageView:            return "UIImageView"
        case .label:                return "UILabel"
        case .button:               return "UIButton"
        case .view:                 return "UIView"
        case .textField:            return "UITextField"
        case .collectionView:       return "UICollectionView"
        case .collectionViewCell:   return "UICollectionViewCell"
        case .stackView:            return "UIStackView"
        case .viewController:       return "UIViewController"
        }
    }
}
