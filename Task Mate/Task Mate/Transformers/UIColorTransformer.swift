//
//  UIColor+Transformer.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import Foundation
import UIKit

/// Class that provides a convenient way to convert between UIColor objects and other types.
class UIColorTransformer: ValueTransformer {
    
    /// Transforms a UIColor to Data.
    ///
    /// - Parameters:
    ///   - value: The value to be transformed.
    ///
    /// - Returns:
    ///   - Data associated with the value specified.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    
    /// Transforms a Data value to UIColor.
    ///
    /// - Parameters:
    ///   - value: The value to be transformed.
    ///
    /// - Returns:
    ///   - UIColor associated with the value specified.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            return nil
        }
    }
}
