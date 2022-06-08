//
//  FileModel.swift
//  UIKitty
//
//  Created by Rittenzore on 13.01.2022.
//

import Foundation
import SwiftyXML

class FileModel {
    
    private var elementGenerator: ElementGenerator
    
    var path: String
    var fileURL: URL?
    var fileName: String = ""
    var content: String = ""
    var generatedContent: String = ""
    var models: InterimModels = []
    var constraintModels: InterimModels = []
    var className: String = ""
    
    private var outlets: Outlets = []
    
    init(path: String) {
        self.path = path
        elementGenerator = ElementGenerator()
        readFile()
    }
    
    private func readFile() {
        guard let url = URL(string: path) else { return }
        fileURL = url
        if let aStreamReader = StreamReader(path: path) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                content.append(line + "\n")
            }
        }
        var fileName = String(
            String(
                url.lastPathComponent.reversed()
            )
                .drop(while: {$0 != "."})
                .reversed()
                .dropLast())
        fileName = "Converted" + fileName
        className = fileName
        self.fileName = fileName + ".swift"
        generatedContent.append(
            elementGenerator.generateHeader(fileName: fileName)
        )
        
        generatedContent.append(
            beginParsing(fileName: fileName)
            //            elementGenerator.generateTemplate(
            //                fileName: fileName, completion: {
            //                    models = []
            //                    return beginParsing()
            //                }
            //            )
        )
    }
    
    private func beginParsing(fileName: String) -> String {
        let xml = XML(string: content, encoding: .utf8)
        let elementType: ViewType = xml.scenes.xml == nil ? .xib : .storyboard
        guard let sourceXML = xml.scenes.xml ?? xml.objects.xml else { return "Error" }
        getXmlChildren(for: sourceXML, level: 0, rootId: nil)
        generateElementProperties()
        return generateSwiftStruct(with: 0, rootId: nil, elementType: elementType)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .filter{!$0.isEmpty}.joined(separator: "\n")
    }
    
    // MARK: - Рекрурсивно пройтись по XML файлу и сгенирировать промежутчоные модели
    func getXmlChildren(for xml: XML, level: Int, rootId: UUID?) {
        for children in xml.xmlChildren {
            switch children.xmlName {
            case "tableView":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getXmlChildren(for: children.prototypes.xml!, level: level + 1, rootId: id)
                
            case "tableViewCell":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getConstraintsInfo(children.tableViewCellContentView.constraints.xml!, level: level + 1, rootId: id)
                getXmlChildren(for: children.tableViewCellContentView.subviews.xml!, level: level + 1, rootId: id)
                
            case "collectionViewCell":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getXmlChildren(for: children.collectionViewCellContentView.subviews.xml!, level: level + 1, rootId: id)
                
            case "collectionView":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getXmlChildren(for: children.cells.xml!, level: level + 1, rootId: id)
                
            case "view":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getXmlChildren(for: children.subviews.xml!, level: level + 1, rootId: id)
                
            case "scene":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getXmlChildren(for: children.objects.xml!, level: level + 1, rootId: id)
                
            case "viewController":
                let id = getInfoAboutXML(children, level: level, rootId: rootId)
                getConstraintsInfo(children.view.constraints.xml!, level: level + 1, rootId: id)
                getXmlChildren(for: children.view.subviews.xml!, level: level + 1, rootId: id)
                
            case "tabBarController":
                elementGenerator.isTabbarExist = true
                
            default:
                getInfoAboutXML(children, level: level, rootId: rootId)
            }
        }
    }
    
    func getConstraintsInfo(_ xml: XML, level: Int, rootId: UUID?) {
        let model = InterimModel(xml: xml, level: level, rootId: rootId)
        constraintModels.append(model)
    }
    
    func getInfoAboutXML(_ xml: XML, level: Int, rootId: UUID?) -> UUID {
        let model = InterimModel(xml: xml, level: level, rootId: rootId)
        models.append(model)
        return model.id
    }
    
    // MARK: - Рекурсивно пройтись по моделям и сгенировать .swift структуру
    func generateSwiftStruct(with nestedIndex: Int, rootId: UUID?, elementType: ViewType, isForOutlets: Bool = true) -> String {
        while nestedIndex <= models.count - 1 {
            var result = ""
            var filteredArray = InterimModels()
            if nestedIndex == 0 {
                filteredArray = models.filter({$0.level == nestedIndex})
            } else {
                filteredArray = models.filter({$0.level == nestedIndex && $0.rootId == rootId})
            }
//            var xmlConstraints: [XML] = []
//            constraintModels.forEach({
//                xmlConstraints.append($0.xml)
//            })
            elementGenerator.constraints = constraintModels
            filteredArray.forEach({ element in
                result.append(
                    elementGenerator.generateElement(
                        fileName: className,
                        from: element.xml,
                        insertingText: generateSwiftStruct(
                            with: nestedIndex + 1,
                            rootId: element.id,
                            elementType: elementType
                        ),
                        elementType: elementType,
                        isForOutlets: isForOutlets
                    )
                )
            })
            return result
        }
        return ""
    }
    
    private func generateElementProperties() {
        outlets.forEach { outlet in
            guard let outletModel = models.first(where: { $0.xml.id == outlet.id }) else { return }
            outlet.insertingText = generateSwiftStruct(with: outletModel.level,
                                                       rootId: outletModel.rootId,
                                                       elementType: .storyboard,
                                                       isForOutlets: false)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)
                .filter{!$0.isEmpty}.joined(separator: "\n")
        }
    }
}
