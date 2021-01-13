//
//  AXValue+DFBase.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/8.
//

import Foundation
import Cocoa

extension AXValue{
    
   
    
    func cgSize() -> CGSize? {
        return self.value() as? CGSize
    }

    func cgPoint() -> CGPoint? {
        return self.value() as? CGPoint
    }

    func cgRect() -> CGRect? {
        return self.value() as? CGRect
    }

    func cfRange() -> CFRange? {
        return self.value() as? CFRange
    }

    func axError() -> AXError? {
        return self.value() as? AXError
    }
  
    func type() -> AXValueType {
        return AXValueGetType(self)
    }
    
    func value() -> Any? {
        
        var isScuess:Bool = false
        return self.value(isScuess: &isScuess)
    }
    
    func value(isScuess:inout Bool) -> Any? {
        
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
    
    static func create(value:Any,type:AXValueType) -> AXValue? {
        var value = value
        return AXValueCreate(type, &value)
    }
    
    static func createCGPoint(point:CGPoint) -> AXValue? {
        return create(value: point, type: AXValueType.cgPoint)
    }
    
    static func createCGSize(size:CGSize) -> AXValue? {
        return create(value: size, type: AXValueType.cgSize)
    }
    
    static func createCGRect(rect:CGRect) -> AXValue? {
        return create(value: rect, type: AXValueType.cgRect)
    }
    
    static func createCFRange(range:CFRange) -> AXValue? {
        return create(value: range, type: AXValueType.cfRange)
    }
    
    static func createAXError(error:AXError) -> AXValue? {
        return create(value: error, type: AXValueType.axError)
    }
}
