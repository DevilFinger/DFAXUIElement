//
//  AXUIElement+DFBase.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/6.
//

import Foundation
import Cocoa



extension AXUIElement:Error{
    
    public func value(attributeKey:String, error:inout AXError) -> Any? {
        var value : AnyObject?
        let axError = AXUIElementCopyAttributeValue(self, attributeKey as CFString, &value)
        error = axError
        if let val = value{
            return AXUIElement.unPackValue(value: val)
        }else{
            return nil
        }
    }
    
    public func value(attributeKey:String) -> Any? {
        var error : AXError = AXError.failure
        return value(attributeKey: attributeKey, error: &error)
    }
    
    public func valueOfAXUIElement(attributeKey:String) -> AXUIElement? {
        var error:AXError = AXError.failure
        return valueOfAXUIElement(attributeKey: attributeKey, error: &error)
    }
    
    public func valueOfAXUIElement(attributeKey:String, error:inout AXError) -> AXUIElement? {
        
        if let value  = self.value(attributeKey: attributeKey, error: &error) as CFTypeRef?{
            if CFGetTypeID(value) == AXUIElementGetTypeID(){
                let elementRef : AXUIElement = value as! AXUIElement
                return elementRef
            }
        }
        error = AXError.failure
        return nil
    }
    
    
    public func values(attributeKey:String, startIndex:Int, endIndex:Int, error: inout AXError) -> [Any?]?   {
        var values : CFArray?
        error = AXUIElementCopyAttributeValues(self, attributeKey as CFString, startIndex as CFIndex, endIndex as CFIndex, &values)
        if error == .success{
            if let vals = values as [AnyObject]?{
                return vals.map({ AXUIElement.unPackValue(value: $0) })
            }
        }
        return nil
    }
    
    public func values(attributeKey:String, startIndex:Int, endIndex:Int) -> [Any?]? {
        var error : AXError = AXError.failure
        return values(attributeKey: attributeKey, startIndex: startIndex, endIndex: endIndex, error: &error)
    }
    
    public func valuesCount(attributeKey:String, error:inout AXError) -> Int {
        var index : CFIndex = 0
        error = AXUIElementGetAttributeValueCount(self, attributeKey as CFString, &index)
        return index as Int
    }
    
    public func valuesCount(attributeKey:String) -> Int {
        var error : AXError = AXError.failure
        return valuesCount(attributeKey: attributeKey, error: &error)
    }
    
    public func names(error:inout AXError) -> [String]? {
        var names : CFArray?
        error = AXUIElementCopyAttributeNames(self, &names)
        if let array = names as? [String]{
            return array
        }
        return nil
    }
    
    public func names() -> [String]? {
        var error:AXError = AXError.failure
        return names(error: &error)
    }
    
    public func actionName(error:inout AXError) ->  [String]? {
        var names : CFArray?
        error = AXUIElementCopyActionNames(self, &names)
        if let array = names as? [String]{
            return array
        }
        return nil
    }
    
    public func actionName() ->  [String]?{
        var error :AXError = AXError.failure
        return actionName(error: &error)
    }
    
    public func actionDescription(actionKey: String, error:inout AXError) -> String {
        var desc : CFString?
        error = AXUIElementCopyActionDescription(self, actionKey as CFString, &desc)
        
        if let str = desc as String?{
            return str
        }
        return ""
    }
    
    public func actionDescription(actionKey: String) -> String {
        var error:AXError = AXError.failure
        return actionDescription(actionKey: actionKey, error: &error)
    }
    
    
    public func action(actionKey:String) -> AXError {
        return AXUIElementPerformAction(self, actionKey as CFString)
    }
    
    
    public func isAttributeSettable(attributeKey:String, error:inout AXError) -> Bool {
        var attributeCanBeSet: DarwinBoolean = false;
        error = AXUIElementIsAttributeSettable(self, attributeKey as CFString, &attributeCanBeSet)
        return attributeCanBeSet.boolValue
    }
    
    public func isAttributeSettable(attributeKey:String) -> Bool {
        var error :AXError = AXError.failure
        return isAttributeSettable(attributeKey: attributeKey, error: &error)
    }
    
    public func set(attributeKey:String, value:Any) -> AXError {
        
        let val = value
        var result : AnyObject
        if value is CGSize{
            result = AXValue.createCGSize(size: val as! CGSize) as AnyObject
        }else if  value is CGPoint{
            result = AXValue.createCGPoint(point: val as! CGPoint) as AnyObject
        }else if value is CGRect{
            result = AXValue.createCGRect(rect: val as! CGRect) as AnyObject
        }else if value is CFRange{
            result = AXValue.createCFRange(range: val as! CFRange) as AnyObject
        }else if value is AXError{
            result = AXValue.createAXError(error: val as! AXError) as AnyObject
        }else{
            result = val as AnyObject
        }
        
        let error = AXUIElementSetAttributeValue(self, attributeKey as CFString, result)
        return error
    }
    
    public func multipleValues(attributeKeys:[String], options:AXCopyMultipleAttributeOptions, error:inout AXError) -> [AnyObject]? {
        var values : CFArray?
        error = AXUIElementCopyMultipleAttributeValues(self, attributeKeys as CFArray, options, &values)
        if error == .success{
            if let vals = values as [AnyObject]?{
                return vals
            }
        }
        return nil
    }
    
    public func multipleValues(attributeKeys:[String], options:AXCopyMultipleAttributeOptions) -> [AnyObject]? {
        var error : AXError = AXError.failure
        return multipleValues(attributeKeys: attributeKeys, options: options, error: &error)
    }

    
    public func parameterizedNames(error:inout AXError) -> [String]? {
        var names : CFArray?
        error = AXUIElementCopyActionNames(self, &names)
        if let array = names as? [String]{
            return array
        }
        return nil
    }
    
    public func parameterizedNames() -> [String]? {
        var error : AXError = AXError.failure
        return parameterizedNames(error: &error)
    }
    
    public func parameterizedValue(parameterizedAttribute:String,parameter:AnyObject, error:inout AXError) -> AnyObject? {
        
        var value:AnyObject?
        error = AXUIElementCopyParameterizedAttributeValue(self, parameterizedAttribute as CFString, parameter, &value)
        return value
    }
    
    public func parameterizedValue(parameterizedAttribute:String,parameter:AnyObject) -> AnyObject?{
        var error : AXError = AXError.failure
        return parameterizedValue(parameterizedAttribute: parameterizedAttribute, parameter: parameter, error: &error)
    }
    
    
    public static func unPackValue(value: AnyObject) -> Any? {
            switch CFGetTypeID(value) {
            case AXUIElementGetTypeID():
                return value as! AXUIElement
            case AXValueGetTypeID():
                let type = AXValueGetType(value as! AXValue)
                let axVal = value as! AXValue
                switch type {
                case .axError:
                    return axVal.axError()
                case .cfRange:
                    return axVal.cfRange()
                case .cgPoint:
                    return axVal.cgPoint()
                case .cgRect:
                    return axVal.cgRect()
                case .cgSize:
                    return axVal.cgSize()
                case .illegal:
                    return value
                @unknown default:
                    return value
                }
            default:
                return value
            }
        }
    
    
    
}

    
    
//    static func unPackValue(value: AnyObject) -> Any {
//            switch CFGetTypeID(value) {
//            case AXUIElementGetTypeID():
//                return value as! AXUIElement
//            case AXValueGetTypeID():
//                let type = AXValueGetType(value as! AXValue)
//                switch type {
//                case .axError:
//                    var result: AXError = .success
//                    let success = AXValueGetValue(value as! AXValue, type, &result)
//                    assert(success)
//                    return result
//                case .cfRange:
//                    var result: CFRange = CFRange()
//                    let success = AXValueGetValue(value as! AXValue, type, &result)
//                    assert(success)
//                    return result
//                case .cgPoint:
//                    var result: CGPoint = CGPoint.zero
//                    let success = AXValueGetValue(value as! AXValue, type, &result)
//                    assert(success)
//                    return result
//                case .cgRect:
//                    var result: CGRect = CGRect.zero
//                    let success = AXValueGetValue(value as! AXValue, type, &result)
//                    assert(success)
//                    return result
//                case .cgSize:
//                    var result: CGSize = CGSize.zero
//                    let success = AXValueGetValue(value as! AXValue, type, &result)
//                    assert(success)
//                    return result
//                case .illegal:
//                    return value
//                @unknown default:
//                    return value
//                }
//            default:
//                return value
//            }
//        }

