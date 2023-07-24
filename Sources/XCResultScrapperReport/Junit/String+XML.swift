import SwiftyXML
import Foundation

extension String {
    func escapedForXMLNode() -> String {
        let node = XMLNode.text(withStringValue: self) as! XMLNode
        return node.xmlString
    }

    func escapedForXMLAttribute() -> String {
        let node = XMLNode.attribute(withName: "", stringValue: self) as! XMLNode
        let string = node.xmlString

        let start = string.index(string.startIndex, offsetBy: 2)
        let end = string.index(string.endIndex, offsetBy: -1)
        let substr = string[start..<end]

        return String(substr)
    }
}
