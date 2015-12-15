//
//  UIColorConveniences.swift
//  Rankzoo
//
//  Created by David Thomas on 2015-06-11.
//  Copyright (c) 2015 Assembly Co. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func colorFromHex(hex: String) -> UIColor {
        
        var cleanedHex = hex.stringByReplacingOccurrencesOfString("#", withString: "")
        
        if (cleanedHex.characters.count < 8) {
            cleanedHex = "FF\(cleanedHex)"
        }
        
        let scanner = NSScanner(string: cleanedHex)
        
        var color:UInt32 = 0
        
        scanner.scanHexInt(&color)

        let alpha = Double((color >> 24) & 0xFF) / 255.0
        let red = Double((color >> 16) & 0xFF) / 255.0
        let green = Double((color >> 8) & 0xFF) / 255.0
        let blue = Double(color & 0xFF) / 255.0
        
        return UIColor(red:CGFloat(red), green:CGFloat(green), blue:CGFloat(blue), alpha:CGFloat(alpha))
    }
    
    
    class func gradientFromColor (color:UIColor, toColor:UIColor, withHeight height:Int) -> UIColor {
        
        let size = CGSize(width:1, height:height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let colors = NSArray(array: [color.CGColor, toColor.CGColor])
        
        let gradient = CGGradientCreateWithColors(colorspace, colors, nil)
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), CGGradientDrawingOptions(rawValue:0));
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return UIColor(patternImage: image)   
        
    }
    
    class func gradientFromColor (color:UIColor, toColor:UIColor, withWidth width:Int) -> UIColor {
        
        let size = CGSize(width:width, height:1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let colors = NSArray(array: [color.CGColor, toColor.CGColor])
        
        let gradient = CGGradientCreateWithColors(colorspace, colors, nil)
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), CGGradientDrawingOptions(rawValue:0));
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return UIColor(patternImage: image)
        
        
        
        
    }
    
    class func argbEvaluate (color:UIColor, toColor:UIColor, animatedValue position:Float) -> UIColor {
        
        var startRed:Float=0.0,startGreen:Float=0.0,startBlue:Float=0.0,startAlpha:Float = 1.0;
        var endRed:Float=0.0,endGreen:Float=0.0,endBlue:Float=0.0,endAlpha:Float = 1.0;
        
        
        func populateColorComponents(inout red:Float, inout green:Float, inout blue:Float, inout alpha:Float,  color:UIColor) {
            
            let components = CGColorGetComponents(color.CGColor)
            
            if (CGColorGetNumberOfComponents(color.CGColor) == 2) {
                
                red = Float(components[0])
                green = Float(components[0])
                blue = Float(components[0])
                alpha = Float(components[1])
                
            } else {
                
                red = Float(components[0])
                green = Float(components[1])
                blue = Float(components[2])
                alpha = Float(CGColorGetAlpha(color.CGColor))
                
            }
        }
        
        populateColorComponents(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha, color: color)
        populateColorComponents(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha, color: toColor)
        
        
        let newRed = linearInterpolate(startRed, toValue: endRed, position: position)
        let newGreen = linearInterpolate(startGreen, toValue: endGreen, position: position)
        let newBlue = linearInterpolate(startBlue, toValue: endBlue, position: position)
        let newAlpha = linearInterpolate(startAlpha, toValue: endAlpha, position: position)
        
        return UIColor(red: CGFloat(newRed), green: CGFloat(newGreen), blue: CGFloat(newBlue), alpha: CGFloat(newAlpha))
        
    }
}