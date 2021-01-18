# DFAXUIElement

这是一个对Accessibility API进行二次封装的Swift库，让你更方便的使用AXUIElement、AXObserver里面的API。

使用Accessibility API 可以对MacOS上所有的程序进行控制，例如对窗体的大小、位置进行获取和设置。

甚至可以获取到窗体的按钮，如最小化按钮。并且模拟点击事件。
## Require

MacOS 10.11+

Swift 4.0+


## 安装

### CocoaPods


要使用[CocoaPods](http://cocoapods.org)进行安装，只需将以下内容添加到您的`Podfile`中：

```
pod 'DFAXUIElement'
```

# Warning

如果想使用Accessibity API，您开发的MacOS APP就必须是非沙盒模式，所以这将很难在苹果商店进行上架。特别是在2012后，苹果新规下，这将变得不可能从正经渠道下进行发布。

如果你开发的苹果正在使用Accessibity API，然而你又必须上架，你可以参考下面的文章。里面有介绍如何去和苹果审核团队进行沟通。 [文章链接](https://stackoverflow.com/questions/32116095/how-to-use-accessibility-with-sandboxed-app)


## 前提条件

### 1. 把你的APP变成非沙盒OS 

```
打开项目的entitlements文件，然后把里面的属性`App Sandbox` 设置成 `NO`
```

### 2. 允许您的APP可以使用 Accessibility API

```
1. 打开System Preferenc -> Security & Privacy -> Accessibiltiy.。
2. 如果列表里面没有您的APP，在最下方有个`+`，点击并且选择您的APP，并且勾选上。
3. 如果列表里面没有Xcode，在最下方有个`+`，点击并且选择您的APP，并且勾选上。
4. 如果列表里面有您的APP，请勾选上。
5. 如果列表里面有您的Xcode，请勾选上。
6. 在确保上述已经设置好后，请重新回到项目，然后clean并且重新编译运行
```

# 使用方法 

### 更多的使用方法，请参考demo项目和源代码

## 1.SandBox Check API:

### 如果您想检查您的APP是否已经是非沙盒模式，可以使用如下方法：

```
//it will return a Bool Value, if ture is sandbox, false is non-sandbox
AXUIElement.isSandboxingEnabled()

```

## 2.判断您的APP是否已经运行使用Accessibility API

这个方法会弹出一个系统层级的alert来询问您是否要使用Accessibility  API。如果用户选择`拒绝` 或者 `还没进行选择`，该alert会弹出。否则该弹出不会弹出。

```
`//it will return a Bool Value, if ture is API enabled, false is API disabled`
let isApiEnable:Bool = AXUIElement.askForAccessibilityIfNeeded()
```

如果您不想要系统层级的弹窗，你可以使用如下方法：

```
`//it will return a Bool Value, if ture is enabled, false is API disabled`
let isApiEnable:Bool = AXUIElement.checkAppIsAllowToUseAccessibilty()

```

## 3.AXUIElement API:

### Base API

#### 根据key获取AXUIElement的值

``` 
let windows : [AXUIElement]? = appRef.value(attributeKey: kAXWindowsAttribute) // appRef is a AXUIElement of Application

//or if you want to get a error, just like this
var error : AXError = AXError.failure
let windows:[AXUIElement]? = appRef.value(attributeKey: kAXWindowsAttribute, error: &error) as? [AXUIElement]

```

#### 根据key对AXUIElement进行设置值

```
let error : AXError = winRef.set(attributeKey: kAXPositionAttribute, value: CGPoint.init(x: x, y: y)) winRef is a AXUIElement of Windows
```

#### 判断key是否可以进行设置。因为有些值是readonly的

```
// winRef is a AXUIElement of Window
let isSettable:Bool = winRef.isAttributeSettable(attributeKey: kAXSizeAttribute)

//or if you want to get a error, just like this
var error:AXError = AXError.failure
let isSettable:Bool = winRef.isAttributeSettable(attributeKey: kAXSizeAttribute,error: &error)```
```

#### 获取AXUIElement的所有attribute（属性）的key

```
// appRef is a AXUIElement of Application
 let attributeNames:[String]? = appRef.names()

//or if you want to get a error, just like this
 var error:AXError = AXError.failure
 let attributeNames:[String]? = appRef.names(error: &error)
```

#### 获取AXUIElement的所有action(事件)的key
```
// appRef is a AXUIElement of Application
let actionNames:[String]? = appRef.actionName()

//or if you want to get a error, just like this
var error:AXError = AXError.failure
let actionNames:[String]? = appRef.actionName(error: &error)

```

#### 使用Action对key进行调用。一般如按钮的点击

```
 //get the minimized button of the window
let minimizedBtnRef:AXUIElement? = winRef.value(attributeKey: kAXMinimizeButtonAttribute) as? AXUIElement //winRef is a AXUIElement

//press the minimized button
minimizedBtnRef?.action(actionKey: kAXPressAction)
```

#### 一个完整的调用代码如下：
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

#### 创建一个AXObserver的Observer对象

 1.声明一个闭包回调

```
let _observerCallbackWithInfo: AXObserverCallbackWithInfo = {  (observer, element, notification, userInfo, refcon) in
	//do something in callback
}
```

2.创建AXObserver对象
```
var axError : AXError = .failure
let observer:AXObserver? = AXObserver.create(pid: self.app.processIdentifier, callBack: _observerCallbackWithInfo, error: &axError)

```

#### 根据指定key创建一个notification，并且该通知是在CFRunLoopDefaultMode

```
func observerAddExampleCode()  {
        if observer != nil  {
        	let selfPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
		let error:AXError = observer!.addNotificationAndCFRunLoopInDefaultMode(observerKey: kAXWindowMovedNotification, element: appRef, refcon: selfPtr)      
        }
 }
```

同时您还有多个调用方式来添加通知：
```
1.public func addNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?, mode:CFRunLoopMode) -> AXError

2.public func addNotification(observerKey: String, element: AXUIElement, refcon: UnsafeMutableRawPointer?) -> AXError
```

#### 根据指定的key移除通知，并且该通知是在CFRunLoopDefaultMode下的

```
func observerRemoveExampleCode() {
        if observer != nil {
            let error:AXError = observer?.removeNotificationAndCFRunLoopInDefaultMode(observerKey: kAXWindowMovedNotification, element: appRef)
        }
}
```

同时您还有多个调用方式来移除通知：
```
1.public func removeNotification(observerKey: String, element: AXUIElement) -> AXError
2.public func removeNotificationAndCFRunLoop(observerKey: String, element: AXUIElement, mode: CFRunLoopMode) -> AXError
```

### DFAXObserverCenter API

#### 这是一个我进行封装的通知单例，可以让你简单的进行添加、移除通知。并且统一管理和调度。


#### 根据指定key创建通知

```
   func centerOfObserverAddExampleCode() {
       _ = DFAXObserverCenter.center.add(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
```

#### 根据指定key移除通知

```
    func centerOfObserverRemoveExampleCode() {
        _ = DFAXObserverCenter.center.remove(pid: app.processIdentifier, observerKey: kAXWindowResizedNotification)
    }
```

#### 只需要设置handler（闭包形式），则可以快捷的获取到回调。

```
DFAXObserverCenter.center.handler = { [weak self] (pid,observerKey, observer, element, info) in
	//do something when notification did called
}
```


3