//
//  ElementGenerator.swift
//  UIKitty
//
//  Created by Rittenzore on 13.01.2022.
//

import Foundation
import XMLCoder
import SwiftyXML

class ElementGenerator {
    private var isPageCotnrolAdded = false
    private var isTextViewAdded = false
    private var isBodyExists = false
    private var isNavBarExist = false
    private var outletsAdded = false
    private var isVc = Bool()
    
    var isTabbarExist = false
    
    var outlets: Outlets = []
    
    var contentViewModel: ContentViewModel?
    
    var constraints: [InterimModel]?
    
    private var customElements = ""
    
    private var fileName: String = ""
    
    init() { }
    
    func generateElement(fileName: String, from xml: XML, insertingText: String, elementType: ViewType, isForOutlets: Bool = true) -> String {
        if !outlets.map({ $0.id }).contains(xml.id) || !isForOutlets {
            guard let element = ElementType(rawValue: xml.xmlName) else {
                return skipElement(insertingText: insertingText, xml: xml)
            }
            switch element {
            case .tableView:
                return generateTableView(insertingText: insertingText, xml: xml)
                
            case .imageView:
                return generateImageView(insertingText: insertingText, xml: xml)
                
            case .label:
                return generateLabel(insertingText: insertingText, xml: xml)
                
            case .tableViewCell:
                if elementType == .xib {
                    contentViewModel = ContentViewModel(elementType: .tableViewCell, elementId: (xml.tableViewCellContentView.xml?.id)!)
                    return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: false)
                } else {
                    return generateTableViewCell(xml: xml)
                }
                
            case .view:
                if elementType == .xib {
                    return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: false)
                } else {
                    return generateView(insertingText: insertingText, xml: xml)
                }
                
            case .button:
                if elementType == .xib {
                    return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: false)
                } else {
                    return generateButton(insertingText: insertingText, xml: xml)
                }
                
            case .stackView:
                switch xml.xmlAttributes["axis"] {
                case "vertical":
                    return generateStackView(axis: .vertical, insertingText: insertingText, xml: xml)
                default:
                    return generateStackView(axis: .horizontal, insertingText: insertingText, xml: xml)
                }
//            case .activityIndicatorView:
//                return generateActivityView(insertingText: insertingText, spaces: spaces, xml: xml)
//            case .pageControl:
//                return generatePageControl(insertingText: insertingText, spaces: spaces, xml: xml)
//            case .switchControl:
//                return generateSwitchControl(insertingText: insertingText, spaces: spaces, xml: xml)
//            case .segmentedControl:
//                return generateSegmentedControl(insertingText: insertingText, spaces: spaces, xml: xml)
//            case .textView:
//                return generateTextView(insertingText: insertingText, spaces: spaces, xml: xml)
                
            case .textField:
                if elementType == .xib {
                    return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: false)
                } else {
                    return generateTextField(insertingText: insertingText, xml: xml)
                }
                
            case .collectionView:
                return generateСollectionView(insertingText: insertingText, xml: xml)
                
            case .collectionViewCell:
                if elementType == .xib {
                    return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: false)
                } else {
                    return generateCollectionViewCell(xml: xml)
                }
                
            case .viewController:
                contentViewModel = ContentViewModel(elementType: .viewController, elementId: (xml.view.xml?.id)!, safeAreaId: (xml.view.viewLayoutGuide.xml?.id)!)
                return generateRootView(classType: element.elementTypeName, fileName: fileName, insertingText: insertingText, xml: xml, isVc: true)
            }
        } else {
            return outlets.first(where: { $0.id == xml.id })!.name
        }
    }
    
    private func generateTableView(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UITableView = {
                    let tableView = UITableView()
                    tableView.translatesAutoresizingMaskIntoConstraints = false
                    return tableView
                }()\n
            """
    }
    
    private func generateСollectionView(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UICollectionView = {
                    let collectionView = UICollectionView()
                    collectionView.axis = .horizontal
                    collectionView..translatesAutoresizingMaskIntoConstraints = false
                    return collectionView
                }()\n
            """
    }
    
    func generateStackView(axis: StackViewAxis, insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UIStackView = {
                    let stackView = UIStackView()
                    stackView.axis = .\(axis)
                    stackView.translatesAutoresizingMaskIntoConstraints = false
                    return stackView
                }()
            """
    }
    
    private func skipElement(insertingText: String = "", xml: XML) -> String {
        return
            """
            \(insertingText)
            """
    }
    
    private func generateLabel(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        let text = xml.xmlAttributes["text"] ?? ""
        return
            """
                private let i\(elementNameStr): UILabel = {
                    let textLabel = UILabel()
                    textLabel.text = "\(text)"
                    textLabel.translatesAutoresizingMaskIntoConstraints = false
                    return textLabel
                }()\n
            """
    }
    
    private func generateTableViewCell(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UITableViewCell = {
                    let cell = UITableViewCell()
                    cell.translatesAutoresizingMaskIntoConstraints = false
                    return cell
                }()
            """
    }
    
    private func generateCollectionViewCell(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UICollectionViewCell = {
                    let cell = UICollectionViewCell()
                    cell.translatesAutoresizingMaskIntoConstraints = false
                    return cell
                }()
            """
    }
    
    private func generateImageView(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        let imageContentMode = xml.contentMode == nil ? "" : "\(String(describing: xml.contentMode))"
        var imageInit = "UIImage: UIImage()"
        if let intial = xml.xmlAttributes["image"] {
            imageInit = "\"\(intial)\""
        }
        return
            """
                private let i\(elementNameStr): UIImageView = {
                    let image = UIImageView()
                    image.image = \(imageInit)\(imageContentMode.isEmpty ? "" : "\nimage.contentMode = \(imageContentMode)")
                    image.translatesAutoresizingMaskIntoConstraints = false
                    return image
                }()\n
            """
    }
    
    private func generateButton(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        let text = insertingText
        let imageInit = xml.buttonImage == nil ? "" : "UIImage(named: \"\(xml.buttonImage!)\")"
        return
            """
                private let i\(elementNameStr): UIButton = {
                    let button = UIButton()\(imageInit.isEmpty ? "" : "\nbutton.image = UIImage(named:\"\(imageInit)\")")\(text.isEmpty ? "" : "\nbutton.text = \(text)")
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()\n
            """
    }
    
    private func generateView(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        return
            """
                private let i\(elementNameStr): UIView = {
                    let view = UIView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
            """
    }
    
    private func generateTextField(insertingText: String = "", xml: XML) -> String {
        let elementNameStr = String((xml.id?.replacingOccurrences(of: "-", with: ""))!)
        let text = insertingText
        return
            """
                private let i\(elementNameStr): UITextField = {
                    let textField = UITextField()
                    textField.text = "\(text)"
                    textField.translatesAutoresizingMaskIntoConstraints = false
                    return textField
                }()
            """
    }
    
    func generateHeader(fileName: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return """
            //
            //  \(fileName).swift
            //
            //  Created by UIKitty on \(formatter.string(from: date)).
            //  Copyright © 2022 Personal Team. All rights reserved.
            //
            \n
            """
    }
    
    func generateTemplate(fileName: String, completion: (() -> String)) -> String {
        return """
            import UIKit

            class \(fileName) {
            
                // MARK: - UI properties
                \(completion())
            }
            
            """
    }
    
    private func generateInit(classType: String) -> String {
        switch classType {
        case "UITableViewCell":
            return """
            override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
                    super.init(style: style, reuseIdentifier: reuseIdentifier)
                    setupView()
                }
            """
            
        case "UIViewController":
            return """
            override func viewDidLoad() {
                    super.viewDidLoad()
                    view.backgroundColor = .white
                    setupView()
                }
            """
            
        default:
            return """
            override init(frame: CGRect) {
                    super.init(frame: frame)
                    backgroundColor = .white
                    setupView()
                }
                                        
            required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            """
        }
    }
    
    private func addViewsOnSubviews() -> String {
        let contentViewId = contentViewModel?.elementId.replacingOccurrences(of: "-", with: "")
        let contentViewSafeAreaId = contentViewModel?.safeAreaId?.replacingOccurrences(of: "-", with: "") ?? "nil"
        
        var constraintRulesString: String = ""
        
        var itemsArray = [String]()
        
        let constraintRules = constraints?.first
        for constraint in constraintRules!.xml.constraint {
            // Проход по первой части констрейнта
            
            var firstItem = constraint.$firstItem.stringValue.replacingOccurrences(of: "-", with: "")
            if firstItem == contentViewId {
                firstItem = contentViewModel!.contentViewTypeString
            }
            
            itemsArray.append(firstItem)
        }
        itemsArray = itemsArray.filter({ $0 != "" })
        itemsArray = Array(Set(itemsArray))
        
        // Добавление сабвьюх на вьюху
        itemsArray.forEach({
            if isVc {
                if $0 != contentViewSafeAreaId {
                    var constraintRule = isVc ? "view." : ""
                    constraintRule.append("addSubview(i\($0))\n        ")
                    constraintRulesString.append(constraintRule)
                }
            } else {
                if $0 != contentViewId {
                    var constraintRule = isVc ? "view." : ""
                    constraintRule.append("addSubview(i\($0))\n        ")
                    constraintRulesString.append(constraintRule)
                }
            }
        })
        
        return "\(constraintRulesString)"
    }
    
    private func generateConstraints() -> String {
        let contentViewId = contentViewModel?.elementId.replacingOccurrences(of: "-", with: "")
        let contentViewSafeAreaId = contentViewModel?.safeAreaId?.replacingOccurrences(of: "-", with: "") ?? "nil"
        var constraintRulesString: String = """
            NSLayoutConstraint.activate([
                
        """
        
        let constraintRules = constraints?.first
        for constraint in constraintRules!.xml.constraint {
            // Проход по первой части констрейнта
            var firstItem = "i\(constraint.$firstItem.stringValue.replacingOccurrences(of: "-", with: ""))"
            if firstItem == "i\(contentViewId)" {
                firstItem = contentViewModel!.contentViewTypeString
            } else if firstItem == "i\(contentViewSafeAreaId)" {
                firstItem = "view.safeAreaLayoutGuide"
            }
            
            if firstItem == "i" {
                firstItem = ""
            }
            
            if firstItem != "" {
                firstItem.append(".")
            }
            let firstAttribute = constraint.constraintFirstAttribute
            
            // Проход по второй части констрейнта
            var secondItem = "i\(constraint.$secondItem.stringValue.replacingOccurrences(of: "-", with: ""))"
            if secondItem == "i\(contentViewId)" {
                secondItem = contentViewModel!.contentViewTypeString
            } else if secondItem == "i\(contentViewSafeAreaId)" {
                secondItem = "view.safeAreaLayoutGuide"
            }
            
            if secondItem != "" {
                secondItem.append(".")
            }
            let secondAttribute = constraint.constraintSecondAttribute
            
            // Создание констрейнт правила
            let constraintRule = "      \(firstItem)\(String(describing: firstAttribute!)).constraint(equalTo: \(secondItem)\(String(describing: secondAttribute!))),\n        "
            constraintRulesString.append(constraintRule)
        }
        constraintRulesString.append("""
            ])
        """)
        return "\(constraintRulesString)"
    }
    
    private func generateRootView(classType: String, fileName: String, insertingText: String = "", xml: XML, isVc: Bool) -> String {
        self.isVc = isVc
        
        var headers: String = ""
        
        let navBarXML = xml.xmlChildren.first(where: {$0.xmlName == "navigationItem"})
        var navBarText = ""
        if navBarXML != nil {
            navBarText = """
                NavigationView {
                    \(insertingText)
                    .navigationBarTitle("\(navBarXML!.xmlAttributes["title"]!)")
                }
            """
        } else {
            navBarText = insertingText
        }
        
        var tabBarText = ""
        
        if isTabbarExist {
            tabBarText = """
            TabView {
                \(navBarText)
                .tabItem {
                    Text("Tab")
                }
            }
            """
        } else {
            tabBarText = navBarText
        }
        
        if isVc {
            headers = """
            \(tabBarText)
            """
        }
                        
        isBodyExists = true
        return isVc ?
            """
            import UIKit
            
            class \(fileName): UIViewController {
                \n
                // MARK: - UI properties
            \(headers)
                \n
                // MARK: - Lifecycle
                \(generateInit(classType: classType))
            }
            
            // MARK: - Private methods
            private extension \(fileName) {
                func setupView() {
                    \(addViewsOnSubviews())
                    \(generateConstraints())
                }
            }

            """
            : """
            import UIKit
            
            class \(fileName): \(classType) {
            
                \n    // MARK: - UI properties
            \(insertingText)
                \n
                // MARK: - Init
                \(generateInit(classType: classType))
            }
            
            // MARK: - Private methods
            private extension \(fileName) {
                func setupView() {
                    \(addViewsOnSubviews())
                    \(generateConstraints())
                }
            }
            """
    }
    
    static func createSceneDelegate(nameOfFile: String) -> String {
        return """
                guard let windowScene = scene as? UIWindowScene else { return }
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: \(nameOfFile)())
                self.window = window
                window.makeKeyAndVisible()
        """
    }
}
