//
//  ViewController+AXObserver.swift
//  DFAXUIElementExample
//
//  Created by raymond on 2021/1/17.
//

import Foundation
import Cocoa
import DFAXUIElement

extension ViewController{
    
    func observerCreateExampleCode() {
        var axError : AXError = .failure
        let obj = AXObserver.create(pid: self.app.processIdentifier, callBack: _observerCallbackWithInfo, error: &axError)
        if axError == .success && observer == nil{
            observer = obj
        }
    }
    
    func observerAddExampleCode()  {
        if observer != nil  {
            let selfPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            let addError :AXError = observer!.addNotification(observerKey: kAXWindowMovedNotification, element: appRef, refcon: selfPtr)
            if addError == .success{
                CFRunLoopAddSource(CFRunLoopGetCurrent(), observer!.runLoopSource(), CFRunLoopMode.defaultMode)
            }
        }
    }
    
    func observerRemoveExampleCode() {
        if observer != nil {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), observer!.runLoopSource(), CFRunLoopMode.defaultMode)
            let error  = observer!.removeNotification(observerKey: kAXWindowMovedNotification, element: appRef)
            if error == .success{
                observer = nil
            }
        }
    }
    
    func centerOfObserverAddExampleCode() {
       _ = DFAXObserverCenter.center.add(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
    
    func centerOfObserverRemoveExampleCode() {
        _ = DFAXObserverCenter.center.remove(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
    
}
