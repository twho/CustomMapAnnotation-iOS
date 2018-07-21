//
//  ResManager.swift
//  CustomMapAnnotation
//
//  Created by Ho, Tsung Wei on 7/17/18.
//  Copyright © 2018 Michael Ho. All rights reserved.
//

import UIKit

open class CMAResManager {
    
    private static let LOG_TAG = "[CustomMapAnnotation ResManager] "
    
    /**
     Get annotation view foreground image.
     
     - Parameter annotImage: the built-in resources of foreground annotation image
     
     Returns a UIImage from built-in resource
     */
    public static func getAnnotImage(_ annotImage: StyledAnnotationView.AnnotationImage) -> UIImage {
        switch annotImage {
        case .error: return UIImage(named: "ic_error")!
        case .police: return UIImage(named: "ic_police")!
        case .hazard: return UIImage(named: "ic_hazard")!
        case .construction: return UIImage(named: "ic_constr")!
        case .crash: return UIImage(named: "ic_crash")!
        case .multiUser: return UIImage(named: "ic_public")!
        case .personal: return UIImage(named: "ic_personal")!
        case .gas: return UIImage(named: "ic_gas")!
        case .charging: return UIImage(named: "ic_charging")!
        }
    }
    
    /**
     Get annotation view background image.
     
     - Parameter annotImage: the built-in resources of background annotation image
     
     Returns a UIImage from built-in resource
     */
    public static func getBgImage(_ annotImage: StyledAnnotationView.BackgroundImage) -> UIImage {
        switch annotImage {
        case .bubble: return UIImage(named: "ic_annot1")!
        case .square: return UIImage(named: "ic_annot2")!
        case .circle: return UIImage(named: "ic_annot3")!
        case .heart: return UIImage(named: "ic_annot4")!
        case .flag: return UIImage(named: "ic_annot5")!
        }
    }
    
    /**
     Get action sheet view image.
     
     - Parameter actionSheetImg: the built-in resources of background annotation image
     
     Returns a UIImage from built-in resource
     */
    public static func getActionSheetImage(_ actionSheetImg: ActionSheetButtonImg) -> UIImage {
        switch actionSheetImg {
        case .like: return UIImage(named: "ic_like")!
        case .dislike: return UIImage(named: "ic_dislike")!
        case .stop: return UIImage(named: "ic_stop")!
        case .pause: return UIImage(named: "ic_pause")!
        case .play: return UIImage(named: "ic_play")!
        case .record: return UIImage(named: "ic_record")!
        }
    }
    
    /**
     Color palette contains color used in the module.
     */
    public struct Color {
        static let gray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        static let ltGray = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0)
        static let gray50 = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
        static let darkGray = UIColor(red:0.37, green:0.37, blue:0.37, alpha:1.0)
        static let ltBlue = UIColor(red:0.00, green:0.59, blue:1.00, alpha:1.0)
        static let red = UIColor(red:0.97, green:0.57, blue:0.53, alpha:1.0)
        
        static func getColorPair(color: UIColor) -> (color: UIColor, tint: UIColor) {
            return (color, color.getDarkColorTint())
        }
    }
    
    /**
     Color theme.
     
     - light:          Light color theme.
     - dark:           Dark color theme.
     - customOneColor: Color theme with one specified color.
     - customColors:   Fully customized color theme.
     */
    public enum Theme {
        case light
        case dark
        case customOneColor
        case customColors
    }
    
    /**
     Color set used for entire theme.
     */
    public struct ThemeColor {
        static let light = (textColor: Color.darkGray, TopBarColor: Color.ltBlue, bgColor: (color: UIColor.white, tint: Color.ltGray))
        static let dark = (textColor: UIColor.white, TopBarColor: Color.ltGray, bgColor: (color: Color.darkGray, tint: Color.ltGray))
    }
    
    /**
     Get a set of colors by theme.
     
     - Parameters:
        - theme:       The Theme of the action sheet.
        - bgColor:     The background color of the action sheet.
        - textColor:   The text color of the entire action sheet.
        - topBarColor: The background color of the top bar.
     */
    public static func getColorByTheme(theme: Theme, bgColor: UIColor? = nil, textColor: UIColor? = nil, topBarColor: UIColor? = nil) -> (textColor: UIColor, TopBarColor: UIColor, bgColor: (color: UIColor, tint: UIColor)) {
        var themeColors = ThemeColor.light
        switch theme {
        case .light:
            themeColors = ThemeColor.light
        case .dark:
            themeColors = ThemeColor.dark
        case .customOneColor:
            if let bgColor = bgColor {
                themeColors = (textColor: bgColor.getAppropriateTextColor(), TopBarColor: bgColor.getLtColorTint(), bgColor: (color: bgColor, tint: bgColor.getDarkColorTint()))
            } else {
                print(LOG_TAG + "You need to declare bgColor to use custom theme.")
            }
        case .customColors:
            if let bgColor = bgColor, let textColor = textColor, let tbColor = topBarColor {
                themeColors = (textColor: textColor, TopBarColor: tbColor, bgColor: (color: bgColor, tint: bgColor.getDarkColorTint()))
            } else {
                print(LOG_TAG + "You need to declare bgColor, textColor and topBarColor to use custom theme.")
            }
        }
        
        return themeColors
    }
}
