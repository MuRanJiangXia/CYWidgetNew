//
//  ViewController.swift
//  CYWidgetNew
//
//  Created by cyan on 2021/2/3.
//

import UIKit
import WidgetKit

// group id
public let groupBundleKey: String = "group.www.cyan.com.CYWidgetNew"

// widget group 指定路径
let widgetMainPath = "/Library/cyan/widget/"

// widget 时钟颜色
let widgetClockColor = "widgetClockColor"
// widget 日历颜色
let widgetCalendarColor = "widgetCalendarColor"

class ViewController: UIViewController {

    lazy var button1: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.purple
        button.setTitle("刷新 1", for: .normal)
        button.addTarget(self, action: #selector(save(btn:)), for:.touchUpInside)
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.purple
        button.setTitle("刷新 2", for: .normal)
        button.addTarget(self, action: #selector(save(btn:)), for:.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatUI()
    }
    
    func creatUI() {
        button1.frame = CGRect(x: 30, y: 70, width: 100, height: 40)
        self.view.addSubview(button1)
    
        button2.frame = CGRect(x: 150, y: 70, width: 100, height: 40)
        self.view.addSubview(button2)
    }
    
    @objc func save(btn: UIButton) {
        let fileManager = FileManager.default
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupBundleKey)

        let mainPath = (url?.path ?? "") + widgetMainPath
        var isFolder: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: mainPath, isDirectory: &isFolder)
        if isExists == false || isFolder.boolValue == false {
            try? fileManager.createDirectory(atPath: mainPath, withIntermediateDirectories: true, attributes: nil)
        }
        // temp1  temp2
        var name = ""
        var color = "000000"
        switch btn {
        case button1:
            name = "temp1"
            color = "000000"
        default:
            name = "temp2"
            color = "ffffff"
        }
        
        let data = UIImage(named: name)?.pngData()
        try? data?.write(to: URL(fileURLWithPath: mainPath + "widget1.jpg"), options: .atomic)

        print("mainPath : \(mainPath)")
        
        let userdefaults = UserDefaults.init(suiteName: groupBundleKey)
        userdefaults?.setValue(color, forKey: widgetClockColor)
        userdefaults?.setValue(color, forKey: widgetCalendarColor)
        userdefaults?.synchronize()
        
        // 立即刷新所有组件
        if #available(iOS 14.0, *) {
            DispatchQueue.main.async {
                WidgetCenter.shared.reloadAllTimelines()
                print("刷新成功")
            }
       
        } else {
            // Fallback on earlier versions
        }
    }
    


}

