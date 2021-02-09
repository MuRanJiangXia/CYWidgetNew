//
//  CYWidgetData.swift
//  CYWidgetExtensionExtension
//
//  Created by cyan on 2021/2/3.
//

import UIKit

// group id
public let groupBundleKey: String = "group.www.cyan.com.CYWidgetNew"

// 图片路径 存储名
let clockWidgetPath = "/Library/cyan/widget/widget1.jpg"

// widget 时钟颜色
let widgetClockColor = "widgetClockColor"
// widget 日历颜色
let widgetCalendarColor = "widgetCalendarColor"

let widgetTargetWidth: CGFloat = 329
let iPhoneHeight = UIScreen.main.bounds.size.height

enum CYWidgetType {
    case clock
    case calendar
    
    var path: String {
        clockWidgetPath
    }

}

struct CYWidgetData {
    let title: String
    let imageName : String
    let image   : UIImage
    let colorStr: String
}

struct CYWidgetDataLoader {
    
    static func getWidgetData(_ type: CYWidgetType) -> CYWidgetData {
        let userdefaults = UserDefaults.init(suiteName: groupBundleKey)
        var colorStr = ""
        switch type {
        case .calendar: colorStr = userdefaults?.string(forKey: widgetCalendarColor) ?? "ffffff"
        case .clock: colorStr = userdefaults?.string(forKey: widgetClockColor) ?? "ffffff"
        }
        
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupBundleKey)
        let imagePath = (url?.path ?? "") + type.path
        print("imagePath:\(imagePath)")
        if let image = UIImage(contentsOfFile: imagePath) {
            return CYWidgetData(title: "title:cyan", imageName: "", image: image, colorStr: colorStr)
        }
        return CYWidgetData(title: "title:cyan", imageName: "", image: UIImage(named: "widgetBackground")!, colorStr: colorStr)
    }
    
}

struct CYDateGenerator {
    
    /// date转字符串
    ///
    /// - Parameters:
    ///   - date: date
    ///   - format: 规格
    /// - Returns: 转后字符串
    static func stringShortWith(date: Date, format: String = "yyMMdd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
//        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    /// 时间转星期
    /// - Parameter date: 时间
    /// - Returns: 星期
    static func week(date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        
        let weekday = components.weekday ?? 0
        return CYWeekDate(rawValue: weekday)?.description ?? ""
    }
}

enum CYWeekDate: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
 
    var description: String {
        switch self {
        case .sunday : return "星期日"
        case .monday : return "星期一"
        case .tuesday : return "星期二"
        case .wednesday : return "星期三"
        case .thursday : return "星期四"
        case .friday : return "星期五"
        default: return "星期六"
        }
    }
    
}


/**

屏幕尺寸 - portrait 小-systemSmall  中-systemMedium 大-systemLarge
414x896 pt (XR/XsMax/11/11ProMax)    169x169pt    360x169pt    360x379pt
375x812 pt (X/Xs/11 Pro)    155x155 pt    329x155 pt    329x345 pt
414x736 pt (6p/6sp/7p)    159x159 pt    348x159 pt    348x357 pt
375x667 pt (6/6s/7/8)    148x148 pt    321x148 pt    321x324 pt
320x568 pt (5/5s/SE)    141x141 pt    292x141 pt    292x311 pt

*/
func RatioLen(_ length: CGFloat) -> CGFloat {
 if iPhoneHeight == 812 {
   return length
 }
 else if iPhoneHeight == 896 {
   return (length * 360 / widgetTargetWidth)
 }
 else if iPhoneHeight == 736 {
   return (length * 348 / widgetTargetWidth)
 }
 else if iPhoneHeight == 667 {
   return (length * 321 / widgetTargetWidth)
 }
 else if iPhoneHeight == 568 {
   return (length * 292 / widgetTargetWidth)
 }
 return length
}

// MARK: - UIColor extension
extension UIColor {
    
    convenience init(hexStr: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexStr)
        
        if #available(iOS 13.0, *) {
            scanner.currentIndex = hexStr.index(hexStr.startIndex, offsetBy: 0)
        } else {
            scanner.scanLocation = 0
        }
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
}
