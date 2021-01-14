//
//  DFNSRunningApplicaitonHelper.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa


public class DFNSRunningApplicaitonHelper:NSObject{
    
    /// 获取当前所有的正在运行的进程APP
    /// - Returns: 返回一个数组，里面全是当前运行的进程
    public static func allApplication() -> Array<NSRunningApplication> {
        return NSWorkspace.shared.runningApplications
    }
    
    
    /// 根据pid获取进程APP
    /// - Parameter pid: 需要获取的进程的pid
    /// - Returns: 返回一个进程。
    public static func runningApplication(pid:Int) -> NSRunningApplication? {
        let runningApp = allApplication()
        for app in runningApp {
            
            if app.processIdentifier == pid {
                return app
            }
        }
        
        return nil
    }
    
    ///  获取当前程序
    public static func curApplication() -> NSRunningApplication {
        return NSRunningApplication.current
        
    }
    
    // 获取当前程序的进程的信息
    public static func curApplicationInfo() -> ProcessInfo {
        
        return ProcessInfo.processInfo
    }
    
    // 获取当前程序的进程的pid
    public static func curApplicationPid() -> pid_t {
        return ProcessInfo.processInfo.processIdentifier
    }
    
    
}
