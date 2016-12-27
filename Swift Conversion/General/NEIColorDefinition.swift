//
//  NEIColorDefinition.m
//  NEIPG
//
//  Created by Gourav Sharma on 11/18/16.
//  Copyright © 2016 Mobileprogrammingllc. All rights reserved.
//

import UIKit

// for 'colorWithHexString' UIColor category
let appWindowBackgroundColor: String = "#161C38"


// Dark grey, #6d6d6d (form text)
let navigationBarTintColor: String = "0xE0E0E0"

// Dark grey, #D9D1D5 (form lines)
let toolBarTintColor: String = "#E0E0E0"


let detailHeaderColor: String = "0xB8CCE4"

extension UIColor {
    
    class func applicationBackgroundColor() -> UIColor {
        
        return UIColor.colorWithHexString(appWindowBackgroundColor)
    }
    
    class func navigationBarTintBackgroundColor() -> UIColor {
        
        return UIColor.colorWithHexString(navigationBarTintColor)
    }
    
    class func toolBarTintBackgroundColor() -> UIColor {
        
        return UIColor.colorWithHexString(toolBarTintColor)
    }
    
    class func detailHeaderBarColor() -> UIColor {
        
        return UIColor.colorWithHexString(detailHeaderColor)
    }

}
