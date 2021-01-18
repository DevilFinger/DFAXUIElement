//
//  AXObserver+Base.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/10.
//

import Foundation
import Cocoa

extension AXObserver {
    
    public static func create(pid:pid_t,callBack:@escaping AXObserverCallback, error:inout AXError) -> AXObserver? {
        var observer : AXObserver?
        error = AXObserverCreate(pid, callBack, &observer)
        return observer
    }
    
    public static func create(pid:pid_t,callBack:@escaping AXObserverCallbackWithInfo, error:inout AXError) -> AXObserver? {
        var observer : AXObserver?
        error = AXObserverCreateWithInfoCallback(pid, callBack, &observer)
        return observer
    }
    
    public func runLoopSource() -> CFRunLoopSource{
        return AXObserverGetRunLoopSource(self)
    }
    
    public func addNotification(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?) -> AXError {
        let error : AXError = AXObserverAddNotification(self, element, observerKey as CFString, refcon)
        return error
    }
    
    public func removeNotification(observerKey: String, element: AXUIElement) -> AXError {
        let error : AXError = AXObserverRemoveNotification(self, element, observerKey as CFString)
        return error
    }
    
    public func addNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?, mode:CFRunLoopMode) -> AXError{
        let error = self.addNotification(observerKey: observerKey, element: element, refcon: refcon)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), self.runLoopSource(), mode)
        return error
    }
    
    public func removeNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, mode: CFRunLoopMode) -> AXError {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.runLoopSource(), mode)
        let error = self.removeNotification(observerKey: observerKey, element: element)
        return error
    }
    
    public func addNotificationAndCFRunLoopInDefaultMode(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?) -> AXError{
        let error = self.addNotification(observerKey: observerKey, element: element, refcon: refcon)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), self.runLoopSource(), CFRunLoopMode.defaultMode)
        return error
    }
    
    public func removeNotificationAndCFRunLoopInDefaultMode(observerKey: String, element: AXUIElement) -> AXError {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.runLoopSource(), CFRunLoopMode.defaultMode)
        let error = self.removeNotification(observerKey: observerKey, element: element)
        return error
    }
    
}
