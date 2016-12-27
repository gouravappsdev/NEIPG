//
//  UIColor+Additions.m
//  DJOGlobal
//
//  Created by Gourav Sharma on 05/11/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit


public extension UIColor {
    /*
    // Alpha hex reference
    
     100% — FF
     95% — F2
     90% — E6
     85% — D9
     80% — CC
     75% — BF
     70% — B3
     65% — A6
     60% — 99
     55% — 8C
     50% — 80
     45% — 73
     40% — 66
     35% — 59
     30% — 4D
     25% — 40
     20% — 33
     15% — 26
     10% — 1A
     5% — 0D
     0% — 00
     
    */
    class func colorWithHexString(_ hexString: String) -> UIColor {
        
        let colorString: String = hexString.replacingOccurrences(of: "#", with: "").uppercased()

            var alpha: CGFloat
        switch colorString.characters.count {
            case 4:
            // #ARGB
                alpha = self.colorComponentFrom(colorString, start: 0, length: 1)
            case 8:
            // #AARRGGBB
                alpha = self.colorComponentFrom(colorString, start: 0, length: 2)
            default:
            // #RGB and #RRGGBB
                alpha = 1.0
        }

        return UIColor.colorWithHexString(hexString, alpha: alpha)
    }

    class func colorWithHexString(_ hexString: String, alpha alphaValue: CGFloat) -> UIColor {
        let colorString: String = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        
        //stringByReplacingOccurrencesOfString("#", withString: "").uppercased()
        let alpha: CGFloat = alphaValue
        var red: CGFloat
        var blue: CGFloat
        var green: CGFloat
        switch colorString.characters.count {
            case 3:
            // #RGB
                red = self.self.colorComponentFrom(colorString, start: 0, length: 1)
                green = self.self.colorComponentFrom(colorString, start: 1, length: 1)
                blue = self.self.colorComponentFrom(colorString, start: 2, length: 1)
            case 4:
            // #ARGB
                red = self.self.colorComponentFrom(colorString, start: 1, length: 1)
                green = self.self.colorComponentFrom(colorString, start: 2, length: 1)
                blue = self.self.colorComponentFrom(colorString, start: 3, length: 1)
            case 6:
            // #RRGGBB
                red = self.self.colorComponentFrom(colorString, start: 0, length: 2)
                green = self.self.colorComponentFrom(colorString, start: 2, length: 2)
                blue = self.self.colorComponentFrom(colorString, start: 4, length: 2)
            case 8:
            // #AARRGGBB
                red = self.self.colorComponentFrom(colorString, start: 2, length: 2)
                green = self.self.colorComponentFrom(colorString, start: 4, length: 2)
                blue = self.self.colorComponentFrom(colorString, start: 6, length: 2)
            default:
                assert(true, "Color value \(hexString) is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB")
                // Return black
                red = 0.0
                green = 0.0
                blue = 0.0
        }

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    class func colorComponentFrom(_ string: String, start: Int, length: Int) -> CGFloat {
        
        let myString = string as NSString
        let substring: String = myString.substring(with: NSRange(location: start, length: length))
        let fullHex: String = length == 2 ? substring : "\(substring)\(substring)"
               var hexComponent:UInt32 = 0
               Scanner(string: fullHex).scanHexInt32(&hexComponent)
        return CGFloat(hexComponent) / 255.0
    }
}

