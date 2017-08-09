//
//  SJAlertController.swift
//  SJAlertController
//
//  Created by 江奔 on 2017/8/9.
//  Copyright © 2017年 TCGroup. All rights reserved.
//

import UIKit

let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
let MAIN_COLOR = UIColor(red: 52/255.0, green: 197/255.0, blue:
    170/255.0, alpha: 1.0)


class SJAlertController: UIViewController {

    let kBakcgroundTansperancy: CGFloat = 0.7
    let kHeightMargin: CGFloat = 10.0
    let KTopMargin: CGFloat = 20.0
    let kWidthMargin: CGFloat = 10.0
    let kAnimatedViewHeight: CGFloat = 70.0
    let kMaxHeight: CGFloat = 300.0
    var kContentWidth: CGFloat = 300.0
    let kButtonHeight: CGFloat = 35.0
    var textViewHeight: CGFloat = 90.0
    let kTitleHeight:CGFloat = 30.0
    var contentView = UIView()
    var titleLabel: UILabel = UILabel()
    var subTitleTextView = UITextView()
    var buttons: [UIButton] = []
    var strongSelf: SJAlertController?
    var userAction:((_ button: UIButton) -> Void)? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)
        self.view.addSubview(contentView)
        
        //强引用 不然按钮点击不能执行
        strongSelf = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -初始化
    fileprivate func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleTextView)
        contentView.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        contentView.layer.borderColor = UIColor.colorFromRGB(0xCCCCCC).cgColor
        view.addSubview(contentView)
        
    }

    
    fileprivate func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size:25)
        titleLabel.textColor = UIColor.colorFromRGB(0x575757)
    }

    
    fileprivate func setupSubtitleTextView() {
        subTitleTextView.text = ""
        subTitleTextView.textAlignment = .center
        subTitleTextView.font = UIFont(name: "Helvetica", size:16)
        subTitleTextView.textColor = UIColor.colorFromRGB(0x797979)
        subTitleTextView.isEditable = false
    }
    
    
    //MARK: -布局
    fileprivate func resizeAndRelayout() {
        let mainScreenBounds = UIScreen.main.bounds
        self.view.frame.size = mainScreenBounds.size
        let x: CGFloat = kWidthMargin
        var y: CGFloat = KTopMargin
        let width: CGFloat = kContentWidth - (kWidthMargin*2)
        
        // Title
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        if self.subTitleTextView.text.isEmpty == false {
            let subtitleString = subTitleTextView.text! as NSString
            let rect = subtitleString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:subTitleTextView.font!], context: nil)
            textViewHeight = ceil(rect.size.height) + 10.0
            subTitleTextView.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
            contentView.addSubview(subTitleTextView)
            y += textViewHeight + kHeightMargin
        }
        
        var buttonRect:[CGRect] = []
        for button in buttons {
            let string = button.title(for: UIControlState())! as NSString
            buttonRect.append(string.boundingRect(with: CGSize(width: width, height:0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSFontAttributeName:button.titleLabel!.font], context:nil))
        }
        
        var totalWidth: CGFloat = 0.0
        if buttons.count == 2 {
            totalWidth = buttonRect[0].size.width + buttonRect[1].size.width + kWidthMargin + 40.0
        }
        else{
            totalWidth = buttonRect[0].size.width + 20.0
        }
        y += kHeightMargin
        var buttonX = (kContentWidth - totalWidth ) / 2.0
        for i in 0 ..< buttons.count {
            
            buttons[i].frame = CGRect(x: buttonX, y: y, width: buttonRect[i].size.width + 20.0, height: buttonRect[i].size.height + 10.0)
            buttonX = buttons[i].frame.origin.x + kWidthMargin + buttonRect[i].size.width + 20.0
            buttons[i].layer.cornerRadius = 5.0
            self.contentView.addSubview(buttons[i])
            
        }
        y += kHeightMargin + buttonRect[0].size.height + 10.0
        if y > kMaxHeight {
            let diff = y - kMaxHeight
            let sFrame = subTitleTextView.frame
            subTitleTextView.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
            for button in buttons {
                let bFrame = button.frame
                button.frame = CGRect(x: bFrame.origin.x, y: bFrame.origin.y - diff, width: bFrame.width, height: bFrame.height)
            }
            
            y = kMaxHeight
        }
        
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - kContentWidth) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: kContentWidth, height: y)
        contentView.clipsToBounds = true
        
        //进入时的动画
        contentView.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.contentView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

}


extension SJAlertController {
    
    //MARK: -alert 方法主体
    func showAlert(_ title: String, subTitle: String?,buttonTitle: String ,otherButtonTitle:String?,action:@escaping ((_ OtherButton: UIButton) -> Void)) {
        userAction = action
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        self.setupContentView()
        self.setupTitleLabel()
        self.setupSubtitleTextView()
        
        self.titleLabel.text = title
        if subTitle != nil {
            self.subTitleTextView.text = subTitle
        }
        buttons = []
        if buttonTitle.isEmpty == false {
            let button: UIButton = UIButton()
            button.setTitle(buttonTitle, for: UIControlState())
            button.backgroundColor = MAIN_COLOR
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(SJAlertController.doCancel(_:)), for: UIControlEvents.touchUpInside)
            button.tag = 0
            buttons.append(button)
        }
        
        if otherButtonTitle != nil && otherButtonTitle!.isEmpty == false {
            let button: UIButton = UIButton(type: UIButtonType.custom)
            button.setTitle(otherButtonTitle, for: UIControlState())
            button.backgroundColor = MAIN_COLOR
            button.addTarget(self, action: #selector(SJAlertController.pressed(_:)), for: UIControlEvents.touchUpInside)
            
            button.tag = 1
            buttons.append(button)
        }
        resizeAndRelayout()
    }
    
    //MARK: -取消
    func doCancel(_ sender:UIButton){
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
            
        }) { (Bool) -> Void in
            self.view.removeFromSuperview()
            self.cleanUpAlert()
            self.strongSelf = nil
        }
    }
    
    fileprivate func cleanUpAlert() {
        self.contentView.removeFromSuperview()
        self.contentView = UIView()
    }
    func pressed(_ sender: UIButton!) {
        if userAction !=  nil {
            userAction!(sender)
        }
        
        // 点击其他按钮也移除视图
        doCancel(sender)
    }
    
    
}


extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

