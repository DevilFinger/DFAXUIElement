//
//  AXUIElement+DFPermissionApplication.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

extension AXUIElement{
 
    public static let systemWide:AXUIElement = AXUIElementCreateSystemWide()
    
    public static func application(pid:pid_t) -> AXUIElement{
       return AXUIElementCreateApplication(pid)
    }
    
    public static func focusedApplication() -> AXUIElement? {
        
        let systemWide = AXUIElement.systemWide
        
        if let app = systemWide.value(attributeKey: kAXFocusedApplicationAttribute) as! AXUIElement? {
            return app
        }else{
            return nil
        }
    }
    
    public static func frontmostApplication() -> AXUIElement?{
        
        if let app = NSWorkspace.shared.frontmostApplication{
            return AXUIElement.application(pid: app.processIdentifier)
        }
        return nil
    }
    
    
    /// 获取指定application在指定x和y下的AXUIElement
    /// - Parameters:
    ///   - app: application的AXUIElement
    ///   - x: 坐标系的X
    ///   - y: 坐标系的Y
    ///   - error: AXError，以此来获取错误信息
    /// - Returns: 符合条件的AXUIElement
    public static func elementAtPositionInApplication(app:AXUIElement, x:Float, y: Float, error:inout AXError) -> AXUIElement? {
        var element : AXUIElement?
        error = AXUIElementCopyElementAtPosition(app, x, y, &element)
        return element
    }
    
    
    /// 获取指定application在指定x和y下的AXUIElement
    /// - Parameters:
    ///   - app: application的AXUIElement
    ///   - x: 坐标系的X
    ///   - y: 坐标系的Y
    /// - Returns: 符合条件的AXUIElement
    public static func elementAtPositionInApplication(app:AXUIElement, x:Float, y: Float) -> AXUIElement? {
        var error : AXError = AXError.failure
        return elementAtPositionInApplication(app: app, x: x, y: y, error: &error)
        
    }
    
    public func pid(error:inout AXError) -> pid_t{
        
        var pid : pid_t = 0
        error = AXUIElementGetPid(self, &pid)
        return pid
    }
    
    public func pid() -> pid_t{
        var error : AXError = AXError.failure
        return pid(error: &error)
    }
    
}


