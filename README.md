# SJAlertController

SJAlertController 是一个弹出提示框的库，使用非常简单，只需导入一个Swift文件即可使用。
使用方法：
```swift
SJAlertController().showAlert("提示", subTitle: "Hello, My name is SteveJones", buttonTitle: "取消", otherButtonTitle:"确定") { (btn) in
            print("按了确定")
        }
```

效果如下：
![](http://oqepgj2jp.bkt.clouddn.com/alert.gif)

使用细节可根据需要修改。

