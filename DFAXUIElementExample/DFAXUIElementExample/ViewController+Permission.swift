//
//  ViewController+Permission.swift
//  DFAXUIElementExample
//
//  Created by raymond on 2021/1/17.
//

import Foundation
import Cocoa

extension ViewController{
   
    func checkAppIsAllowForAccessibilityAPI(prompt:Bool) -> Bool {
        //to check the application is not sandbox
        if AXUIElement.isSandboxingEnabled(){
            showSandBoxAlert()
            return false
        }
        if prompt{
            if !AXUIElement.askForAccessibilityIfNeeded(){
                // if want to prompt,use AXUIElement.askForAccessibilityIfNeeded() this to check AXAPI is Enabled
                return false
            }
            return true
        }else{
            if !AXUIElement.checkAppIsAllowToUseAccessibilty(){
                // if don't want to prompt, use AXUIElement.checkAppIsAllowToUseAccessibilty() this to check AXAPI is Enabled
                showFaileAlert()
                return false
            }
            return true
        }
        
    }
    
    
    func showSucessAlert() {
        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.informativeText = "checkPermission"
        alert.messageText = "Your Application is Allow to Use AXUIElement"
        alert.runModal()
    }
    
    func showSandBoxAlert() {
        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.accessoryView = NSView.init(frame: NSRect.init(x: 0, y: 0, width: 500, height: 0))
        alert.addButton(withTitle: "OK")
        alert.informativeText = """
            1) Your application is sandBox, Please Change it to not a sandbox APP.

            2) Go to Your Project -> Find entitlements File.

            3) Change the property "App Sandbox" to "No".

            4) after that , clean and rebuild it.

            """
        alert.messageText = "AXAPI is Not Enable, Because Application is Sanbox!"
        let action = alert.runModal()
        if action == NSApplication.ModalResponse.alertFirstButtonReturn{
            NSApp.terminate(nil)
        }
    }
    
    func showFaileAlert() {
        let alert = NSAlert.init()
        alert.alertStyle = .warning
        alert.accessoryView = NSView.init(frame: NSRect.init(x: 0, y: 0, width: 500, height: 0))
        alert.addButton(withTitle: "Open \"Security & Privacy\" ")
        alert.messageText = "AXAPI is Not Enable, Because Application is not in Security & Privacy"
        alert.informativeText = """
            1)Your Application is Not Allow to Use AXUIElement.

            2)Please go to System Preferenc -> Security & Privacy -> Accessibiltiy.

            3)if the list dont have your application, press the "+" button to add it

            4)if the list have your application, check it.

            5) after that , clean and rebuild it.

        """
        let action = alert.runModal()
        if action == NSApplication.ModalResponse.alertFirstButtonReturn{
            
            let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            NSWorkspace.shared.open(prefpaneUrl)
            
        }
    }
       
}
