# DFAXUIElement

[中文教程](https://github.com/DevilFinger/DFAXUIElement/blob/main/README-Chinese.md)

This is a Swift version to let you use Accessibility API with AXUIElement、AXObserver.

It's a fastway to let you control the MacOS application which is running.

Such as get Application window's size、position、 or set the specify value to window's size、postition。

Event if you could get the window minimized button element and press it in coding.

## Version

v.1.0.7

## Require

MacOS 10.11+

Swift 4.0+


## Installation

### CocoaPods

For installation with [CocoaPods](http://cocoapods.org), simply add the following to your `Podfile`:

```
pod 'DFAXUIElement'
```

# Warning

When you use the Accessibity API, your MacOS App must be in a non-sandbox mode. So it is difficult to publish in the Apple Store. Especially after the 2012.

If your app must use Accessiblity API, you can refer to the following article. There are instructions on how to publish to the Apple Store. [Click it](https://stackoverflow.com/questions/32116095/how-to-use-accessibility-with-sandboxed-app)


## Before to Use

### 1. Change APP to non-sanbox mode. 

```
open the entitlements in your project, and change the property `App Sandbox` to `NO`
```

### 2. Let Your App Allow Use Accessibility

```
1. Go to System Preferenc -> Security & Privacy -> Accessibiltiy.
2. if the list don't have your application, press the "+" button to add it
3. if the list don't have Xcode, press the "+" button to add it
4. if the list have your application, check it.
5. if the list have Xcode, check it.
5) after that , clean and rebuild it.
```

# How To Use 

### For more usage methods, please refer to demo！

## 1.SandBox Check API:

### If you want to check the Application is Sanbox mode,you could use like this

```
AXUIElement.isSandboxingEnabled()

it will return a Bool Value, if ture is sandbox, false is non-sandbox
```

## 2.API Enable Check API:
If u want to check the Application is enable to Use Accessibility API or not, you could use this function as the follow 

This will pop up a system-level dialog box for you to choose, when the user selects `deny` or `not determine`.

```
`//it will return a Bool Value, if ture is API enabled, false is API disabled`
let isApiEnable:Bool = AXUIElement.askForAccessibilityIfNeeded()
```

Or you don't want to have a prompt,just try this:

```
`//it will return a Bool Value, if ture is enabled, false is API disabled`
let isApiEnable:Bool = AXUIElement.checkAppIsAllowToUseAccessibilty()

```

## 3.AXUIElement API:

### Base API

#### Get AXUIElement Value with Key

``` 
let windows : [AXUIElement]? = appRef.value(attributeKey: kAXWindowsAttribute) // appRef is a AXUIElement of Application

//or if you want to get a error, just like this
var error : AXError = AXError.failure
let windows:[AXUIElement]? = appRef.value(attributeKey: kAXWindowsAttribute, error: &error) as? [AXUIElement]

```

#### AXUIElement Value with Key

```
let error : AXError = winRef.set(attributeKey: kAXPositionAttribute, value: CGPoint.init(x: x, y: y)) winRef is a AXUIElement of Windows
```

#### Check the key is settable

```
// winRef is a AXUIElement of Window
let isSettable:Bool = winRef.isAttributeSettable(attributeKey: kAXSizeAttribute)

//or if you want to get a error, just like this
var error:AXError = AXError.failure
let isSettable:Bool = winRef.isAttributeSettable(attributeKey: kAXSizeAttribute,error: &error)```
```

#### Get AXUIElement All Attribute Name

```
// appRef is a AXUIElement of Application
 let attributeNames:[String]? = appRef.names()

//or if you want to get a error, just like this
 var error:AXError = AXError.failure
 let attributeNames:[String]? = appRef.names(error: &error)
```

#### Get AXUIElement All Action Name

```
// appRef is a AXUIElement of Application
let actionNames:[String]? = appRef.actionName()

//or if you want to get a error, just like this
var error:AXError = AXError.failure
let actionNames:[String]? = appRef.actionName(error: &error)

```

#### Action the AXUIElement With Key

```
 //get the minimized button of the window
let minimizedBtnRef:AXUIElement? = winRef.value(attributeKey: kAXMinimizeButtonAttribute) as? AXUIElement //winRef is a AXUIElement

//press the minimized button
minimizedBtnRef?.action(actionKey: kAXPressAction)
```

#### A complete example code is as follows
```
//Get the AXUIElementRef of current application
        var appRef = AXUIElement.application(pid: DFNSRunningApplicaitonHelper.curApplication().processIdentifier)
        if let windows : [AXUIElement] = appRef.windows(){
            for window in windows {
                
                //Base API to get value with key
                let position = window.value(attributeKey: kAXPositionAttribute)
                if window.isAttributeSettable(attributeKey: kAXPositionAttribute){//Base API to Check key is settable
                    //Base API to set key with value
                    window.set(attributeKey: kAXPositionAttribute, value: CGPoint.init(x: 100, y: 100))
                }
                
                //Fastway to get attribute of position in window AXUIElement
                let position2 = window.position()
                //Fastway to set attribute of position in window AXUIElement
                window.setPosition(point: CGPoint.init(x: 100, y: 100))
                
                //this get all attribute of Window AXUIElement sample code
                let attributeNames = window.names()
                
                //this get all action of Window AXUIElement sample code
                let actionNames = window.actionName()
                
                //Base API to get minimized button of window AXUIElement
                let minimizedButton2 = window.value(attributeKey: kAXMinimizeButtonAttribute)
                //Fast way to get minimized button of window AXUIElement
                let minimizedButton = window.minimizeBotton()
                
                //action the key in specify AXUIElement
                minimizedButton?.action(actionKey: kAXPressAction)
                
                
                //this is a minmized sample code in different way
                
                //1.set attribute way
                window.minimized(true)
                
                //2.press button
                let minimizedButton2 = window.minimizeBotton()
                minimizedButton2?.action(actionKey: kAXPressAction)
            }
        }

``` 

## 3.AXObserver API:

### Base API

#### Create a Observer of AXObserver

 1.define a callback closure

```
let _observerCallbackWithInfo: AXObserverCallbackWithInfo = {  (observer, element, notification, userInfo, refcon) in
	//do something in callback
}
```

2.create observer obj of AXObserver
```
var axError : AXError = .failure
let observer:AXObserver? = AXObserver.create(pid: self.app.processIdentifier, callBack: _observerCallbackWithInfo, error: &axError)

```

#### Add specify key notification in CFRunLoopDefaultMode

```
func observerAddExampleCode()  {
        if observer != nil  {
        	let selfPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
		let error:AXError = observer!.addNotificationAndCFRunLoopInDefaultMode(observerKey: kAXWindowMovedNotification, element: appRef, refcon: selfPtr)      
        }
 }
```

In addition, the following methods are provided for calling to add Notification
```
1.public func addNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?, mode:CFRunLoopMode) -> AXError

2.public func addNotification(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?) -> AXError
```

#### Remove notification with specify key in CFRunLoopDefaultMode

```
func observerRemoveExampleCode() {
        if observer != nil {
            let error:AXError = observer?.removeNotificationAndCFRunLoopInDefaultMode(observerKey: kAXWindowMovedNotification, element: appRef)
        }
}
```

In addition, the following methods are provided for calling to remove Notification
```
1.public func removeNotification(observerKey: String, element: AXUIElement) -> AXError
2.public func removeNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, mode: CFRunLoopMode) -> AXError
```

### DFAXObserverCenter API

#### Use DFAXObserverCenter observer will be automatically created and destroyed, and unified management and scheduling,just like notificationCenter


#### Add specify key notification in DFAXObserverCenter

```
   func centerOfObserverAddExampleCode() {
       _ = DFAXObserverCenter.center.add(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
```

#### Remove notification with specify key in DFAXObserverCenter

```
    func centerOfObserverRemoveExampleCode() {
        _ = DFAXObserverCenter.center.remove(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
```

#### Add callback handler closure where you want to receive

```
DFAXObserverCenter.center.handler = { [weak self] (pid,observerKey, observer, element, info) in
	//do something when notification did called
}
```


