//
//  Staged.swift
//  UIKitty
//
//  Created by Rittenzore on 13.01.2022.
//

import Foundation
import Cocoa
import SwiftyXML

typealias InterimModels = [InterimModel]

class InterimModel {
    
    var id: UUID = UUID()
    var xml: XML
    var level: Int
    var rootId: UUID?
    
    init(xml: XML, level: Int, rootId: UUID?) {
        self.xml = xml
        self.level = level
        self.rootId = rootId
    }
    
    func getDecription() -> String {
        return "Name \(xml.xmlName) level \(level)"
    }
}

extension XML {
    
    var constraintFirstAttribute: String? {
        get {
            if let constraintFirstAttribute = self.xmlAttributes["firstAttribute"] {
                switch constraintFirstAttribute {
                case "centerX":
                    return "centerXAnchor"
                case "centerY":
                    return "centerYAnchor"
                case "top":
                    return "topAnchor"
                case "left":
                    return "leftAnchor"
                case "leading":
                    return "leadingAnchor"
                case "bottom":
                    return "bottomAnchor"
                case "right":
                    return "rightAnchor"
                case "trailing":
                    return "trailingAnchor"
                default: return nil
                }
            } else {
                return nil
            }
        }
    }
    
    var constraintSecondAttribute: String? {
        get {
            if let constraintSecondAttribute = self.xmlAttributes["secondAttribute"] {
                switch constraintSecondAttribute {
                case "centerX":
                    return "centerXAnchor"
                case "centerY":
                    return "centerYAnchor"
                case "top":
                    return "topAnchor"
                case "left":
                    return "leftAnchor"
                case "leading":
                    return "leadingAnchor"
                case "bottom":
                    return "bottomAnchor"
                case "right":
                    return "rightAnchor"
                case "trailing":
                    return "trailingAnchor"
                default: return nil
                }
            } else {
                return nil
            }
        }
    }
    
    var id: String? {
        get {
            if let id = self.xmlAttributes["id"] {
                return id
            } else {
                return nil
            }
        }
    }
    
    var buttonImage: String? {
        get {
            if let color = self.xmlChildren.first(where: { $0.xmlName == "state" }),
               let imageName = color.xmlAttributes["image"] {
                return imageName
            } else {
                return nil
            }
        }
    }
    
    var contentMode: String? {
        get {
            if let contentMode = xmlChildren.first(where: { $0.xmlName == "contentMode" }) {
                return contentMode.xmlValue
            } else {
                return nil
            }
        }
    }
    
    var color: NSColor? {
        get {
            if let color = self.xmlChildren.first(where: { $0.xmlName == "color" }),
               let red = Double(color.xmlAttributes["red"] ?? ""),
               let green = Double(color.xmlAttributes["green"] ?? ""),
               let blue = Double(color.xmlAttributes["blue"] ?? ""),
               let alpha = Double(color.xmlAttributes["alpha"] ?? "") {
                return NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
            } else {
                return nil
            }
        }
    }
}
