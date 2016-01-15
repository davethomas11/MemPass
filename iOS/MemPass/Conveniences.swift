//
//  Conveniences.swift
//  Rankzoo
//
//  Created by alex on 2015-05-10.
//  Copyright (c) 2015 Assembly Co. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


func doInBackground<T>(closure:()->T, after:(T)->Void) {
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
        let result:T = closure()
        dispatch_async(dispatch_get_main_queue()) {
            after(result)
        }
    }
}

internal func hasInternet() -> Bool {
    
    guard let reacher = Reachability.reachabilityForInternetConnection() else {
    
        return false
    }
    
    return reacher.isReachable()
    
    
}

/**
* Shows Activity indicator. Returns view to dismiss it
*/
internal func busy(controller:UIViewController) -> UIView {
  
    let overlay = UIView(frame: UIScreen.mainScreen().bounds)
    overlay.backgroundColor = UIColor.colorFromHex("#70000000")
    let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    activity.startAnimating()
    activity.center = overlay.center
    overlay.addSubview(activity)
    
    controller.view.addSubview(overlay)
    
    
    return overlay
    
}

internal func linearInterpolate(value:Float, toValue:Float, position:Float) -> Float {
    
    return (1.0 - position) * value + position * toValue;
}

/**
*  Syntactic sugar for optionals
*/
extension Optional {

    /// alternatively, let _ = optional might be clearer you're not going to use it
    var hasValue: Bool { return self != nil }

    /**
    
    Provide unwrapped value with
      optionalValue.or(defaultValue)
    instead of
      optionalValue ? optionalValue! : defaultValue
    
    - parameter defaultValue: if we're not set
    
    - returns: unwrapped self or default
    */
    func or(defaultValue: Wrapped) -> Wrapped {
        switch(self) {
        case .None:
            return defaultValue
        case .Some(let value):
            return value
        }
    }
}

/**
Or if you'd like hasValue as a function

- parameter value: an optional

- returns: whether it has a value
*/
func hasValue<T>(value: T?) -> Bool {
    switch (value) {
    case .Some(_): return true
    case .None: return false
    }
}

/**
*  Syntactic sugar for strings
*/
extension String {
    
    /// for the common use case of not bothering with a comment
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    /// for the properly done use case of including a comment
    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment)
    }
    
    /// truncate user names from beginning to toIndex
    func truncateUsername(toIndex: Int) -> String {
        if self.characters.count > toIndex {
            return self.substringToIndex(self.startIndex.advancedBy(toIndex)) + "..."
        } else {
            return self
        }
    }
    
    var isEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        return matchesRegex(regex)
    }
    
    func matchesRegex(regex: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let matches = test.evaluateWithObject(self)
        return matches
    }
}

/// supports formatGroup()
let _groupFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    return formatter
    }()

/// supports formatDelta()
let _deltaFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.positivePrefix = "+"
    return formatter
    }()

/**
*  Easy number formatting
*/
extension Int {
    /// for grouping with commas
    public func formatGroup() -> String? {
        return _groupFormatter.stringFromNumber(self)
    }
    
    /// for grouping with commas and leading +
    public func formatDelta() -> String? {
        return _deltaFormatter.stringFromNumber(self)
    }
    
    public func suffix() -> String {
        if (self == 0) {
            return ""
        }
        
        let absSelf = abs(self)
        
        switch (absSelf % 100) {
            
        case 11...13:
            return "th"
        default:
            switch (absSelf % 10) {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    }
}


extension Int64 {
    
    public func abrvNum(decimalPlaces:Int=2) -> String {
        var num = self
        
        if (num < 1000) {
            return String(num)
        }
        
        func abreviate(number:Int64, denom:Int64, abrvo:String) -> String {
            
            let floatingPoint = Float(num) / Float(denom)
            
            let multiplier = powf(10, Float(decimalPlaces))
            let roundDown = floorf(floatingPoint * multiplier) / multiplier
            
            let resultStr = NSString(format: "%.\(decimalPlaces)f", roundDown)
            
            return resultStr.stringByAppendingString(abrvo)
        }
        
        var abrvos:[String] = ["K","M","B","T","Q"]
        var step:Int64 = 1000
        
        var abreviated:String?
        
        for (var i = 0; i < abrvos.count; i++) {
            
            if (num > step) {
                abreviated = abreviate(num, denom: step, abrvo: abrvos[i])
            }
            
            step *= 1000
        }
        
        if let returnValue = abreviated {
            return returnValue
        } else {
            return abreviate(num, denom: step, abrvo: "QQ")
        }
    }
    
    public func suffix() -> String {
        let absSelf = abs(self)
        
        switch (absSelf % 100) {
            
        case 11...13:
            return "th"
        default:
            switch (absSelf % 10) {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    }
}

/**
*  Navigation helpers
*/
extension UIViewController {

    /**
        Perform a rewind segue if possible, otherwise show new instance. Expects to be within a navigation controller.

     - parameter rewind: Name of rewind segue, must match method name without ':'
     - parameter show: Name of show segue
     */
    func gotoController(unwind: String, show: String) {
        let action = Selector(unwind + ":")
        if let target = navigationController?.viewControllerForUnwindSegueAction(action, fromViewController: self, withSender: self)
        {
            assert(target.canPerformUnwindSegueAction(action, fromViewController: self, withSender: self))
            performSegueWithIdentifier(unwind, sender: self)
        } else {
            performSegueWithIdentifier(show, sender: self)
        }
    }
}

/*
* UIImage helpers
*/
extension UIImage {
    /*
    * Take in a color and size and return a rectangle of color and size as UIImage
    * see: http://stackoverflow.com/questions/24795035/swift-extra-argument-in-call
    */
    class func getColorRectAsImage(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(rect)
        let rectImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectImage
    }
    
    
}

extension UIImageView {
    func startAnimatingWithCallback(callback:() -> Void) {
        self.startAnimating()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            while(self.isAnimating()) { usleep(10000); }
            dispatch_async(dispatch_get_main_queue()) {
                callback()
            }
        }
        
        
    }
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}


extension UIView {
    
    func hide(duration:NSTimeInterval=0.4, callback:(()->Void)?=nil) {
        
        if (!hidden) {

            UIView.animateWithDuration(duration, animations: {
                self.alpha = 0
                }, completion: { (completed) in
                    self.hidden = true
                    if callback != nil {
                        callback!()
                    }
            })
            
            
        }
        
    }
    
    func show(duration:NSTimeInterval=0.4, callback:(()->Void)?=nil) {
        
        if (hidden) {
            self.hidden = false
            self.alpha = 0
            
            UIView.animateWithDuration(duration, animations: {
                self.alpha = 1
                }, completion: { (completed) in
                    
                    if callback != nil {
                        callback!()
                    }
            })
        }
        
    }

    func toggle(duration:NSTimeInterval=0.4, callback:(()->Void)?=nil) {
        if (hidden) {
            show(duration, callback:callback)
            
        } else {
            hide(duration, callback:callback)
            
        }
    }
    
    func setHiddenAnimated(hide:Bool, duration:NSTimeInterval=0.4, callback:(()->Void)?=nil) {
        
        if (hide) {
            self.hide(duration, callback:callback)
            
        } else {
            show(duration, callback:callback)
            
        }
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}








