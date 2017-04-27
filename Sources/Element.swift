//
//  Element.swift
//  Themify
//
//  Created by Ronaldo Faria Lima on 25/04/17.
//
//

import Foundation

class Element : Hashable {
    typealias AttributeApplier = (UIAppearance, Attribute) -> ()
    fileprivate let elementClassMap: [ElementType : (class: AnyClass, applier: AttributeApplier)] = [
        .label: (class: UILabel.self, applier: { (proxy, attribute) in
            let labelProxy = proxy as! UILabel
            switch attribute {
            case .backgroundColor(let color):
                labelProxy.backgroundColor = color
            case .foregroundColor(let color):
                labelProxy.textColor = color
            }
        }),
        .navigationBar: (class: UINavigationBar.self, applier: { (proxy, attribute) in
            let navProxy = proxy as! UINavigationBar
            switch attribute {
            case .backgroundColor(let color):
                navProxy.backgroundColor = color
            case .foregroundColor(let color):
                navProxy.tintColor = color
            }
        }),
        .toolBar: (class: UIToolbar.self, applier: { (proxy, attribute) in }),
        .tabBar         : (class: UITabBar.self         , applier: { (proxy, attribute) in }),
        .tableViewCell  : (class: UITableViewCell.self  , applier: { (proxy, attribute) in })
    ]
    var attributes = Set<Attribute>()
    var container  : Element?
    let elementType: ElementType
    
    var hashValue: Int {
        return elementType.hashValue
    }
    
    var elementClass: AnyClass? {
        return elementClassMap[elementType]?.class
    }
    
    var attributeApplier: AttributeApplier? {
        return elementClassMap[elementType]?.applier
    }
    
    var proxy: UIAppearance? {
        return (elementClass as? UIAppearance.Type)?.appearance()
    }
    
    func proxy(within containers: [UIAppearanceContainer.Type]) -> UIAppearance? {
        return (elementClass as? UIAppearance.Type)?.appearance(whenContainedInInstancesOf: containers)
    }
    
    init (elementType: ElementType) {
        self.elementType = elementType
    }
    
    static func == (a: Element, b: Element) -> Bool {
        return a.elementType == b.elementType
    }
    
    func addAttribute(attribute: Attribute) {
        attributes.insert(attribute)
    }
    
    func applyAttributes() {
        var appearanceProxy: UIAppearance!
        if let container = container, let typeClass = container.elementClass {
            appearanceProxy = self.proxy(within: [typeClass as! UIAppearanceContainer.Type])
        } else {
            appearanceProxy = self.proxy
        }
        if appearanceProxy == nil {
            // Failed to get a proxy? Do nothing. Probably, we have a configuration issue
            return
        }
        for attribute in attributes {
            attributeApplier?(appearanceProxy, attribute)
        }
    }
}
