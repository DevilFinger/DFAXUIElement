//
//  ViewController.swift
//  DFAXUIElementExample
//
//  Created by raymond on 2021/1/16.
//

import Cocoa
import DFAXUIElement

class ViewController: NSViewController {
    
    @IBOutlet var observerLogView: NSTextView!
    @IBOutlet weak var appTblView: NSTableView!
    @IBOutlet weak var windowTblView: NSTableView!
    
    @IBOutlet weak var AppAttributeNameTblVIew: NSTableView!
    @IBOutlet weak var windowAttributeTblView: NSTableView!
    
    @IBOutlet weak var windowActionTblView: NSTableView!
    
    @IBOutlet weak var windowTitleLbl: NSTextField!
    @IBOutlet weak var windowIDLbl: NSTextField!
    @IBOutlet weak var windowRoleLbl: NSTextField!
    
    @IBOutlet weak var windowIsMinimizedLbl: NSTextField!
    @IBOutlet weak var windowIsFullScreenLbl: NSTextField!
    
    @IBOutlet weak var posXTF: NSTextField!
    @IBOutlet weak var posYTF: NSTextField!
    @IBOutlet weak var widthTF: NSTextField!
    @IBOutlet weak var heighTF: NSTextField!
    
    @IBOutlet weak var windowsCountLbl: NSTextField!
    
    var appList : [NSRunningApplication] = []
    
    var appAttributeNameList : [String] = []
    
    var windowList : [AXUIElement] = []
    
    var windowAttributeNameList : [String] = []
    
    var windowActionList : [String] = []
    
    //Get the current Application
    var app : NSRunningApplication = DFNSRunningApplicaitonHelper.curApplication()
    
    
    
    //Get the AXUIElementRef in current application
    var appRef = AXUIElement.application(pid: DFNSRunningApplicaitonHelper.curApplication().processIdentifier)
    
    //Current AXUIElement of Window
    var windowRef : AXUIElement?
    
    //Current AXObserver Obj
    var observer : AXObserver?
    
    // this is AXObserver callback
    let _observerCallbackWithInfo: AXObserverCallbackWithInfo = {  (observer, element, notification, userInfo, refcon) in
        print("AxObserver Callback did called")
        let log = """
        Start : Observer CallBack Did Call
        * And give u some infomateion,as the follow:
        * observer: \(observer)
        * element : \(element)
        * notificationKey : \(notification)
        * userInfo: \(userInfo)
        * refcone: \(String(describing: refcon))
        end \n
        """
        
        if let ref = refcon{
            let obj : ViewController =  Unmanaged<ViewController>.fromOpaque(ref).takeUnretainedValue()
            obj.observerLogView.string += log
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        //DFAXObserverCenter handler
        //Get the notificaiton with this closure
        DFAXObserverCenter.center.handler = { [weak self] (pid,observerKey, observer, element, info) in
            print("DFAXObserverCenter handler did called")
            print("application pid  \(pid)")
            print("observer key  \(observerKey)")
            print("AXUIElement \(element)")
            print("userInfo \(String(describing: info))")
            
            
            let log = """
            start :DFAXObserverCenter CallBack Did Call
            * And give u some infomateion,as the follow:
            * pid: \(pid)
            * observer: \(observer)
            * element : \(element)
            * observerKey : \(observerKey)
            * userInfo: \(String(describing: info))
            end \n
            """
            
            self?.observerLogView.string += log
        }
        
        
        appTblView.delegate = self
        appTblView.dataSource = self
        
        windowTblView.delegate = self
        windowTblView.dataSource = self;
        
        windowAttributeTblView.delegate = self
        windowAttributeTblView.dataSource = self;
        
        windowActionTblView.delegate = self
        windowActionTblView.dataSource = self;
        
        AppAttributeNameTblVIew.delegate = self
        AppAttributeNameTblVIew.dataSource = self;
        
      
        
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if checkAppIsAllowForAccessibilityAPI(prompt: true){
            getData()
        }
    }
    
    
    func getData() {
        DispatchQueue.main.async {
            [weak self] in
            self?.getAllApplication()
            self?.getApplicationAllAttributeNames()
            self?.setAppInfo()
            self?.getWindowList()
            self?.getWindowAllAttributeNames()
            self?.getWindowAllActionNames()
            self?.setWindowInfo()
            
            self?.observerCreateExampleCode()
            self?.observerAddExampleCode()
            self?.centerOfObserverAddExampleCode()
        }
    }
    
    
    
    
    func getAllApplication(){
        
        app = DFNSRunningApplicaitonHelper.curApplication()
        appRef = AXUIElement.application(pid: DFNSRunningApplicaitonHelper.curApplication().processIdentifier)
        
        appList.removeAll()
        let list = DFNSRunningApplicaitonHelper.allApplication()
        for item in list{
            //find out the application has one more window.
            //or the widnow  is less than one window ,skip it
            if let windows = AXUIElement.application(pid: item.processIdentifier).windows(){
                if windows.count > 0{
                    appList.append(item)
                }
            }
        }
        appTblView.reloadData()
    }
    
    func getApplicationAllAttributeNames(){
        appAttributeNameList.removeAll()
        //get Application AXUIElement all action names
        if let appAttributes = appRef.names(){
            self.appAttributeNameList = appAttributes
        }else{
            self.appAttributeNameList = []
        }
        self.AppAttributeNameTblVIew.reloadData()
    }
    
    
    func setAppInfo() {
        //get this AXUIElement  attribute value count.
        windowsCountLbl.stringValue = "this application has \(String(appRef.valuesCount(attributeKey: kAXWindowsAttribute))) windows. as the follow:"
    }
    
    func getWindowList(){
        //get application AXUIElement all window( the return value is  [AXUIElement]?)
        //use the attribute key is kAXWindowsAttribute
        windowList.removeAll()
        if let windows = appRef.windows(){
            windowList = windows
        }
        self.windowTblView.reloadData()
        
        
        //get application AXUIelement the widows who is focused
        windowRef = appRef.focusedWindow()
        if windowRef == nil{
            windowRef = appRef.mainWindow()
        }
        if windowRef == nil{
            windowRef = windowList[0]
        }
    }
    
    func getWindowAllAttributeNames() {
        windowAttributeNameList.removeAll()
        if let winRef = windowRef{
            //get window all attribute key names
            windowAttributeNameList = winRef.names() ?? []
        }
        windowAttributeTblView.reloadData()
    }
    
    func getWindowAllActionNames() {
        windowActionList.removeAll()
        if let winRef = windowRef{
            //get window all action key names
            windowActionList = winRef.actionName() ?? []
            
        }
        windowActionTblView.reloadData()
    }
    
    func setWindowInfo()  {
        if let window = windowRef{
            
            windowTitleLbl.stringValue = window.title() ?? "undefined"
            print("window title \(String(describing: window.title()))")
            print("other way to get window title \(String(describing: window.value(attributeKey: kAXTitleAttribute)))")
            
            windowIDLbl.stringValue = String(window.windowID())
            print("window ID \(String(describing: window.windowID()))")
            
            windowRoleLbl.stringValue = window.role() ?? "undefined"
            print("window role \(String(describing: window.role()))")
            print("other way to get window role \(String(describing: window.value(attributeKey: kAXRoleAttribute)))")
            
            if let isMini = window.isMinimized(){
                windowIsMinimizedLbl.stringValue = String(isMini)
            }else{
                windowIsMinimizedLbl.stringValue = "undefined"
            }
            print("window isMinimized \(String(describing: window.isMinimized()))")
            print("other way to get window isMinimized \(String(describing: window.value(attributeKey: kAXMinimizedAttribute)))")
            
            if let isFull = window.isFullScreen(){
                windowIsFullScreenLbl.stringValue = String(isFull)
            }else{
                windowIsFullScreenLbl.stringValue = "undefined"
            }
            print("window isFullScreen \(String(describing: window.isFullScreen()))")
            print("other way to get window isFullScreen \(String(describing: window.value(attributeKey: kAXFullscreenAttribute)))")
            
            if let origin = window.position(){
                posXTF.stringValue = String(Double(origin.x))
                posYTF.stringValue = String(Double(origin.y))
                print("window position \(String(describing: window.position()))")
                print("other way to get window position \(String(describing: window.value(attributeKey: kAXPositionAttribute)))")
            }
            
            if let size = window.size(){
                widthTF.stringValue = String(Double(size.width))
                heighTF.stringValue = String(Double(size.height))
            }
            print("window size \(String(describing: window.size()))")
            print("other way to get window size \(String(describing: window.value(attributeKey: kAXSizeAttribute)))")
        }
        else{
            windowTitleLbl.stringValue =  "undefined"
            windowIDLbl.stringValue = "undefined"
            windowRoleLbl.stringValue = "undefined"
            windowIsMinimizedLbl.stringValue = "undefined"
            windowIsFullScreenLbl.stringValue = "undefined"
            posXTF.stringValue = "undefined"
            posYTF.stringValue = "undefined"
            widthTF.stringValue = "undefined"
            heighTF.stringValue = "undefined"
        }
        
        
        
    }
    
    @IBAction func minimizedBtnDidClicked(_ sender: Any) {
        if let winRef = windowRef{
            if let isMini = winRef.isMinimized(){
                // minimized the window
                _ = winRef.minimized(!isMini)
                // or you could try this to minimized the window
                //_ = winRef.set(attributeKey: kAXMinimizedAttribute, value: true)
            }
        }
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
    }
    
    
    @IBAction func fullScreenBtnDidClicked(_ sender: Any) {
        if let winRef = windowRef{
            //Get the AXUIElement of fullscreen button in window
            if let fullBtn = winRef.fullScreenButton(){
                //press the fullscreen button
                _ = fullBtn.press()
                // or your could press the fullscreen button like this
                //let fullScreenButtonRef2 = appRef.focusedWindow()?.fullScreenButton()
                //_ = fullScreenButtonRef2?.action(actionKey: kAXPressAction)
            }
        }
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
    }
    
    @IBAction func setPositionBtnDidClicked(_ sender: Any) {
        
        var posX = 0.0
        if let x = Double(posXTF.stringValue){
            posX = x
        }
        
        var posY = 0.0
        if let y = Double(posYTF.stringValue){
            posY = y
        }
        
        if let winRef = windowRef{
            //if u want to know a attribute key is settable , you could try this
            let isSettable = winRef.isAttributeSettable(attributeKey: kAXPositionAttribute)
                print("kAXPositionAttribute is Settable \(isSettable)")
                if isSettable{
                    //Set window to specify position
                    _ = winRef.setPosition(point: CGPoint.init(x: posX, y: posY))
                    // or you could try this to set position
                    _ = winRef.set(attributeKey: kAXPositionAttribute, value: CGPoint.init(x: posX, y: posY))
                }
        }
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
        
        
    }
    
    @IBAction func clearBtnDidClicked(_ sender: Any) {
        self.observerLogView.string = ""
    }
    
    @IBAction func setSizeBtnDidClicked(_ sender: Any) {
        
        var width = 0.0
        if let wid = Double(widthTF.stringValue){
            width = wid
        }
        
        var height = 0.0
        if let hei = Double(heighTF.stringValue){
            height = hei
        }
        
        if let winRef = windowRef{
            //if u want to know a attribute key is settable , you could try this
            let isSettable = winRef.isAttributeSettable(attributeKey: kAXSizeAttribute)
                print("kAXSizeAttribute is Settable \(isSettable)")
                if isSettable{
                    //Set window to specify size
                    _ = winRef.setSize(size: CGSize.init(width: width, height: height))
                    // or you could try this to set size
                    //_ = winRef.set(attributeKey: kAXSizeAttribute, value: CGSize.init(width: 100, height: 100))
                }
        }
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
        
    }
    
    
    
    @IBAction func checkBoxDidClicked(_ sender: NSButton) {
        DFAXObserverCenter.center.removeAll()
        observerRemoveExampleCode()
    
        app = appList[sender.tag]
        appRef = AXUIElement.application(pid: app.processIdentifier)
        appTblView.reloadData()
        setAppInfo()
        getApplicationAllAttributeNames()
        
        getWindowList()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
        
        observerCreateExampleCode()
        observerAddExampleCode()
        centerOfObserverAddExampleCode()
        
        
    }
    
    @IBAction func windowActionBtnDidClicked(_ sender: NSButton) {
        
        let actionKey = sender.identifier?.rawValue
        if let winRef = windowRef, let key = actionKey{
            _ = winRef.action(actionKey: key)
           
            
        }
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
    }
    
    
    @IBAction func windowCheckBtnDidClicked(_ sender: NSButton) {
        windowRef = windowList[sender.tag]
        windowTblView.reloadData()
        getWindowAllAttributeNames()
        getWindowAllActionNames()
        setWindowInfo()
        
    }
    
    @IBAction func reloadData(_ sender: Any) {
        
        if checkAppIsAllowForAccessibilityAPI(prompt: true){
            getData()
        }
        
    }
    
}

