//
//  CYWidgetColock.swift
//  CYWidgetExtensionExtension
//
//  Created by cyan on 2021/2/3.
//

import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: CYWidgetDataLoader.getWidgetData(.clock))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), data: CYWidgetDataLoader.getWidgetData(.clock))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        // 调试用
//        let currentDate = Date()
//        var entries: [SimpleEntry] = []
//        for offset in 0..<10 {
//            let entryDate = Calendar.current.date(byAdding: .second, value: offset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, data: CYWidgetDataLoader.getWidgetData(.clock))
//            entries.append(entry)
//        }
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
        // 最多五分钟刷新一次
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        for offset in 0..<12 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, data: CYWidgetDataLoader.getWidgetData(.clock))
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
                
    }
}

private struct CYClockTime {
    var sec: Int
    var min: Int
    var hour: Int
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: CYWidgetData
    
    func clockTime() -> CYClockTime {
        let date = self.date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        return CYClockTime(sec: sec, min: min, hour: hour)
    }
}

private struct CYWidgetCalendarView: View {
    var entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Image(uiImage: entry.data.image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            ForEach(1..<13, id: \.self){ i in
                let sinX = sin(CGFloat(i)*30.0/180.0*CGFloat.pi)
                let sinY = -cos(CGFloat(i)*30.0/180.0*CGFloat.pi)
                let color = Color(UIColor(hexStr: entry.data.colorStr))
                Text("\(i)")
                    .foregroundColor(color)
                    .font(.system(size: RatioLen(14)))
                    .frame(width: RatioLen(16), height: RatioLen(16), alignment: .center)
                    .offset(x: 60*sinX, y: 60*sinY)
            }
            
            // sec
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 2, height: RatioLen(40), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                .offset(y: -10)
//                .rotationEffect(.init(degrees: Double(entry.clockTime().sec*6)))

            // min
            Rectangle()
                .fill(Color.blue)
                .frame(width: 2, height: RatioLen(30), alignment: .center)
                .offset(y: -15)
                .rotationEffect(.init(degrees: Double(entry.clockTime().min*6)))
            
            let hour = Double(entry.clockTime().min)*0.5 + Double(entry.clockTime().hour)*30.0
            // hour
            Rectangle()
                .fill(Color.primary)
                .frame(width: 2, height: RatioLen(20), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(y: -10)
                .rotationEffect(.init(degrees: Double(hour)))

        }
    }
}


struct CYWidgetClock: Widget {
    let kind = "CYWidgetClock"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CYWidgetCalendarView(entry: entry)
        }
        .configurationDisplayName("时钟")
        .description("这是时钟~")
        .supportedFamilies([.systemSmall])
    }
}

struct WidgetPlay_Previews1: PreviewProvider {
    static var previews: some View {
        let data = CYWidgetDataLoader.getWidgetData(.clock)
        CYWidgetCalendarView(entry: SimpleEntry(date: Date(), data: data))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

