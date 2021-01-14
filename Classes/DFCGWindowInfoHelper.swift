//
//  DFCGWindowInfoHelper.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/7.
//

import Foundation
import Cocoa

public class DFCGWindowInfoHelper : NSObject {
    
    public static func getCGWindowInfoList(option: CGWindowListOption, windowId:CGWindowID) -> [[String:Any]]? {
        let infos = CGWindowListCopyWindowInfo(option , windowId) as? [[ String : Any]]
        return infos
    }
    
    public static func getCGWindowInfoListInDesktopAndOnlyScreen() -> [[String:Any]]?{
        let infos = CGWindowListCopyWindowInfo(CGWindowListOption(rawValue: CGWindowListOption.optionOnScreenOnly.rawValue | CGWindowListOption.excludeDesktopElements.rawValue) , kCGNullWindowID) as? [[ String : Any]]
        return infos
    }
    
    public static func CGWindowInfoListOnlyScreen() -> [[String:Any]]?{
        let infos = CGWindowListCopyWindowInfo(CGWindowListOption(rawValue: CGWindowListOption.optionOnScreenOnly.rawValue ) , kCGNullWindowID) as? [[ String : Any]]
        return infos
    }
    
    public static func getCGWindowInfo(windowNumber:Int,option: CGWindowListOption) -> [String : Any]? {
        
        if let windowsInfos = getCGWindowInfoList(option: option, windowId: kCGNullWindowID){
            for dict in windowsInfos {
                let winNum : Int = dict[kCGWindowNumber as String] as! Int
                if winNum == windowNumber {
                    return dict
                }
            }
            return nil
        }else{
            return nil
        }
    }
}
