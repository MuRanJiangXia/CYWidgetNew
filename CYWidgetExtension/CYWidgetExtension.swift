//
//  CYWidgetExtension.swift
//  CYWidgetExtension
//
//  Created by cyan on 2021/2/3.
//

import WidgetKit
import SwiftUI
import Intents


// MARK: -  多个组件 入口
@main
struct GameWidgets: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        CYWidgetCalendar()
        CYWidgetClock()
    }
}
