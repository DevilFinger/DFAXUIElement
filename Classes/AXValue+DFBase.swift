//
//  AXValue+DFBase.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/8.
//

import Foundation
import Cocoa

extension AXValue{
    
    public func cgSize() -> CGSize? {
        return self.value() as? CGSize
    }

    public func cgPoint() -> CGPoint? {
        return self.value() as? CGPoint
    }

    public func cgRect() -> CGRect? {
        return self.value() as? CGRect
    }

    public func cfRange() -> CFRange? {
        return self.value() as? CFRange
    }

    public func axError() -> AXError? {
        return self.value() as? AXError
    }
  
    public func type() -> AXValueType {
        return AXValueGetType(self)
    }
    
    public func value() -> Any? {
        
        var isScuess:Bool = false
        return self.value(isScuess: &isScuess)
    }
    
    public func value(isScuess:inout Bool) -> Any? {
        
        let type = self.type()
        switch type {
        case .axError:
            var value:AXError = AXError.failure
            isScuess = AXValueGetValue(self, self.type(), &value)
            return value
        case .cgSize:
            var value : CGSize = CGSize.zero
            isScuess = AXValueGetValue(self, self.type(), &value)
            return value
        case .cgPoint:
            var value:CGPoint = CGPoint.zero
            isScuess = AXValueGetValue(self, self.type(), &value)
            return value
        case .cgRect:
            var value:CGRect = CGRect.zero
            isScuess = AXValueGetValue(self, self.type(), &value)
            return value
        case .cfRange:
            var value:CFRange = CFRange()
            isScuess = AXValueGetValue(self, self.type(), &value)
            return value
        case .illegal:
            isScuess = false
            return nil
        default:
            isScuess = false
            return nil
        }
    }
    
    public static func create(value:Any,type:AXValueType) -> AXValue? {
        var value = value
        return AXValueCreate(type, &value)
    }
    
    public static func createCGPoint(point:CGPoint) -> AXValue? {
        return create(value: point, type: AXValueType.cgPoint)
    }
    
    public static func createCGSize(size:CGSize) -> AXValue? {
        return create(value: size, type: AXValueType.cgSize)
    }
    
    public static func createCGRect(rect:CGRect) -> AXValue? {
        return create(value: rect, type: AXValueType.cgRect)
    }
    
    public static func createCFRange(range:CFRange) -> AXValue? {
        return create(value: range, type: AXValueType.cfRange)
    }
    
    public static func createAXError(error:AXError) -> AXValue? {
        return create(value: error, type: AXValueType.axError)
    }
}
