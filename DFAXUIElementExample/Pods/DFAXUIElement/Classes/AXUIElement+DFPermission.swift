//
//  AXUIElement+DFPermission.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

extension AXUIElement{
    public static func askForAccessibilityIfNeeded() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }
    
    public static func checkAppIsAllowToUseAccessibilty() -> Bool {
        return AXIsProcessTrusted()
    }
    
    public static func isSandboxingEnabled() -> Bool {
        let environment = ProcessInfo.processInfo.environment
        return environment["APP_SANDBOX_CONTAINER_ID"] != nil
    }
    
}
