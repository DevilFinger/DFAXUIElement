//
//  AXUIElement+DFAction.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

extension AXUIElement{
    
    /// Simulate clicking the UIElement, such as a button.
    public func press() -> AXError {
        return self.action(actionKey: kAXPressAction)
    }
    
    /// Increment the value of the UIElement.
    public func increment() -> AXError {
        return self.action(actionKey: kAXIncrementAction)
    }
    
    /// Decrement the value of the UIElement.
    public func decrement() -> AXError {
        return self.action(actionKey: kAXDecrementAction)
    }
    
    /// Simulate pressing Return in the UIElement, such as a text field.
    ///
    /// Don't know if this is still correct. Is this what used to be kAXAcceptAction?
    public func confirm() -> AXError {
        return self.action(actionKey: kAXConfirmAction)
    }
    
    /// Simulate a Cancel action, such as hitting the Cancel button.
    public func cancel() -> AXError {
        return self.action(actionKey: kAXCancelAction)
    }
    
    /// Show alternate or hidden UI.
    ///
    /// This is often used to trigger the same change that would occur on a mouse hover.
    public func showAlternateUI() -> AXError {
        return self.action(actionKey: kAXShowAlternateUIAction)
    }
    
    /// Show default UI.
    ///
    /// This is often used to trigger the same change that would occur when a mouse hover ends.
    public func showDefaultUI() -> AXError {
        return self.action(actionKey: kAXShowDefaultUIAction)
    }
    
    
    public func raise() -> AXError {
        return self.action(actionKey: kAXRaiseAction)
    }
    
    public func showMenu() -> AXError {
        return self.action(actionKey: kAXShowMenuAction)
    }
    
    public func pick() -> AXError {
        return self.action(actionKey: kAXPickAction)
    }
}
