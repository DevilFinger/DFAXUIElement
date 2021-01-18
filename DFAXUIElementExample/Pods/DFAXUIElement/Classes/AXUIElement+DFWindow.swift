//
//  AXUIElement+DFWindow.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

extension AXUIElement{
    
    public static func windowsWithApplication(app:AXUIElement) -> [AXUIElement]? {
        return app.windows()
    }
    
    public static func windowsWithApplication(pid:pid_t) -> [AXUIElement]?{
        let app = AXUIElement.application(pid: pid)
        return app.windows()
    }
    
    public static func windowsWithWindowId(winId:CGWindowID) -> [AXUIElement]?{
        
        if let winInfo = DFCGWindowInfoHelper.getCGWindowInfo(windowNumber: Int(winId), option: CGWindowListOption(rawValue: CGWindowListOption.optionOnScreenOnly.rawValue )){
            let pid = winInfo[kCGWindowOwnerPID as String] as! Int
            let app = AXUIElement.application(pid: pid_t(pid))
            return app.windows()
        }
        return nil
    }
    
    
    public static func focusedWindowInFocusedApplication() -> AXUIElement?{
        if let app = AXUIElement.focusedApplication(){
            return AXUIElement.focusedWindowInApplication(app: app)
        }
        return nil
    }
    
    public static func focusedWindowInFrontmostApplication() -> AXUIElement?{
        
        if let app = AXUIElement.frontmostApplication(){
            return AXUIElement.focusedWindowInApplication(app: app)
        }
        return nil
    }
    
    public static func focusedWindowInApplication(app:AXUIElement) -> AXUIElement? {
        
        if let winRef = app.value(attributeKey: kAXFocusedWindowAttribute) as! AXUIElement?{
            return winRef
        }
        return nil
    }
    
    public static func mainWindowInFrontmostApplication() -> AXUIElement?{
        
        if let app = AXUIElement.frontmostApplication(){
            return mainWindowInApplication(app: app)
        }
        return nil
    }
    
    public static func mainWindowInApplication(app:AXUIElement) -> AXUIElement? {
        
        if let winRef = app.value(attributeKey: kAXMainWindowAttribute) as! AXUIElement?{
            return winRef
        }
        return nil
    }
    
    /// 私有API  通过Window的AXUIElement获取对应的windowID.
    /// 必须建立桥接文件，然后在文件里面暴露私有API的声明 “AXError _AXUIElementGetWindow(AXUIElementRef element, CGWindowID *identifier);”
    /// - Parameter element:Window的AXUIElement
    /// - Returns: 返回对应的windowID
    public func windowID() -> CGWindowID {
        var windowID:CGWindowID = 0
        _AXUIElementGetWindow(self, &windowID)
        return windowID
    }
    
}


//    static public func frontmostWindowInFrontmostApplication() -> AXUIElement?{
//
//        if let app = AXUIElement.frontmostApplication(){
//            if let winRef = app.value(attributeKey: kAXFrontmostAttribute) as! AXUIElement?{
//                return winRef
//            }
//        }
//        return nil
//
//    }
//
//    static public func frontmostWindowInApplication(app:AXUIElement) -> AXUIElement?{
//
//        if let winRef = app.value(attributeKey: kAXFrontmostAttribute) as! AXUIElement?{
//            return winRef
//        }else{
//            return nil
//        }
//    }
