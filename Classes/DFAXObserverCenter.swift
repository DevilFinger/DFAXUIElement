//
//  DFAXObserverCenter.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/10.
//

import Foundation
import Cocoa

public typealias DFAXObserverHandler = (pid_t,String, AXObserver, AXUIElement, CFDictionary?) -> Void

struct DFAXObserverKeyAndPID {
    let pid: pid_t
    let key : String
}

struct DFAXObserverObjAndPID {
    var observer: AXObserver?
    var pid : pid_t
}


class DFAXObserverCenter{
    
    static let center = DFAXObserverCenter()
    
    private var _observers : [DFAXObserverObjAndPID] = []
    private var _observerKeys:[DFAXObserverKeyAndPID] = []
    
    var handler: DFAXObserverHandler?
    var axObservers: [DFAXObserverObjAndPID]{
        get{
            return _observers
        }
    }
    
    var axObserverKeys : [DFAXObserverKeyAndPID]{
        get{
            return _observerKeys
        }
    }
    
    func add(pid:pid_t,observerKey:String) -> AXError {
        
        let axObserver : AXObserver? = getAXObserver(pid: pid)
        if let observer = axObserver{
            let element = AXUIElement.application(pid: pid)
            let selfPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            let error = observer.addNotificationAndCFRunLoopInDefaultMode(observerKey: observerKey, element: element, refcon: selfPtr)
            if error == AXError.success{
                let obj : DFAXObserverKeyAndPID = DFAXObserverKeyAndPID(pid: pid, key: observerKey)
                _observerKeys.append(obj)
            }
            return error
        }else{
            if _create(pid: pid) != nil{
                return add(pid: pid, observerKey: observerKey)
            }
            return AXError.failure
        }
        
    }
    
    func remove(pid:pid_t,observerKey: String) -> AXError {
        
        let axObserver : AXObserver? = getAXObserver(pid: pid)
        if let observer = axObserver{
            let element = AXUIElement.application(pid: pid)
            let error = observer.removeNotificationAndCFRunLoopInDefaultMode(observerKey: observerKey, element: element)
            if error == AXError.success{
                _removeKey(pid: pid, key: observerKey)
                let filterArrs =  _observerKeys.filter { (item) -> Bool in
                    if item.pid == pid{
                        return true
                    }
                    return false
                }
                if  filterArrs.count <= 0{
                    _removeObserver(pid: pid)
                }
                
            }
            return error
        }
        return AXError.failure
    }
    
    func removeAll() {
        
        for obj in _observerKeys {
            _ = remove(pid: obj.pid, observerKey: obj.key)
        }
    }
    
    func removeAll(pid:pid_t)  {
        
        for obj in _observerKeys {
            if obj.pid == pid{
                _ = remove(pid: obj.pid, observerKey: obj.key)
            }
        }
    }
    
    private func _removeAllKey(pid:pid_t)  {
        _observerKeys.removeAll { (item) -> Bool in
            let obj: DFAXObserverKeyAndPID = item
            if obj.pid == pid{
                return true
            }
            return false
        }
    }
    
    private func _removeKey(pid:pid_t, key:String){
        _observerKeys.removeAll { (item) -> Bool in
            let obj: DFAXObserverKeyAndPID = item
            if obj.pid == pid && obj.key == key{
                return true
            }
            return false
        }
    }
    
    private func _removeObserver(pid:pid_t){
        _observers.removeAll { (item) -> Bool in
            let obj : DFAXObserverObjAndPID = item
            if obj.pid == pid{
                return true
            }
            return false
        }
    }
    
    func getAXObserver(pid:pid_t) -> AXObserver? {
        for obj in _observers {
            if obj.pid == pid{
                return obj.observer
            }
        }
        return nil
    }
    
    func getPID(observer:AXObserver) -> pid_t? {
        for obj in _observers {
            if obj.observer == observer{
                return obj.pid
            }
        }
        return nil
    }
    
    func isKeyExistInPid(pid:pid_t, observerKey:String) -> Bool {
        let obj = getAXObserverKeyAndPID(pid: pid, observerKey: observerKey)
        if obj != nil{
            return true
        }
        return false
    }
    
    func getAXObserverKeyAndPID(pid:pid_t, observerKey:String) -> DFAXObserverKeyAndPID? {
        for obj in _observerKeys {
            if obj.pid == pid && obj.key == observerKey{
                return obj
            }
        }
        return nil
    }
    
    private func _create(pid:pid_t) -> AXObserver? {
        
        var error:AXError = AXError.failure
        let observer = AXObserver.create(pid: pid, callBack: _observerCallbackWithInfo, error: &error)
        if error == AXError.success && observer != nil{
            let obj : DFAXObserverObjAndPID = DFAXObserverObjAndPID(observer: observer!, pid: pid)
            _observers.append(obj)
        }
        return observer
    }
    
    //      let m1 =  Unmanaged<DFMouseMonitorManger>.fromOpaque(refcon!).takeUnretainedValue()
    //      let mmm = refcon?.assumingMemoryBound(to: DFMouseMonitorManger.self).pointee
    private let _observerCallbackWithInfo: AXObserverCallbackWithInfo = {  (observer, element, notification, userInfo, refcon) in
        if let ref = refcon{
            let caller : DFAXObserverCenter =  Unmanaged<DFAXObserverCenter>.fromOpaque(ref).takeUnretainedValue()
            if caller.handler != nil{
                caller.handler!(element.pid(), notification as String, observer, element, userInfo)
            }
            
        }
    }
}
