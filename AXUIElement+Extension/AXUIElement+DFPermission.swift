//
//  AXUIElement+DFPermission.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

extension AXUIElement{
    static public func askForAccessibilityIfNeeded() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }
    
    static public func checkAppIsAllowToUseAccessibilty() -> Bool {
        return AXIsProcessTrusted()
    }
}
