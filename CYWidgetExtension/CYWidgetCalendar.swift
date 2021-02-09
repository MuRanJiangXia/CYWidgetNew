//
//  CYWidgetCalendar.swift
//  CYWidgetExtensionExtension
//
//  Created by cyan on 2021/2/3.
//

import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: CYWidgetDataLoader.getWidgetData(.calendar))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), data: CYWidgetDataLoader.getWidgetData(.calendar))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .second, value: 0, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, data: CYWidgetDataLoader.getWidgetData(.calendar))
        let timeLine = Timeline(entries: [entry], policy: .atEnd)
        completion(timeLine)
        
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: CYWidgetData
}

private struct CYWidgetCalendarView: View {
    var entry: SimpleEntry
    
    var body: some View {
        ZStack {
            Image(uiImage: entry.data.image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: RatioLen(10))

                Text(CYDateGenerator.stringShortWith(date: entry.date, format: "M月d日"))
                    .fontWeight(.bold)
                    .font(.system(size: RatioLen(26)))
                    .foregroundColor(Color(UIColor(hexStr: entry.data.colorStr)))
                    .multilineTextAlignment(.leading)
                    .padding(.leading,17)
                Text(CYDateGenerator.week(date: entry.date))
                    .fontWeight(.bold)
                    .font(.system(size: RatioLen(18)))
                    .foregroundColor(Color(UIColor(hexStr: entry.data.colorStr)))
                    .multilineTextAlignment(.leading)
                    .padding(.leading,17)

                Spacer()
                    .frame(height: RatioLen(90))
            }
            .frame(width: RatioLen(329), height: RatioLen(155), alignment: .leading)
        }
        .widgetURL(URL(string: "https://www.baidu.com/calendar"))
    }
    
}


struct CYWidgetCalendar: Widget {
    let kind = "CYWidgetCalendar"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CYWidgetCalendarView(entry: entry)
        }
        .configurationDisplayName("日历")
        .description("这是日历~")
        .supportedFamilies([.systemMedium])
    }
}

struct WidgetPlay_Previews: PreviewProvider {
    static var previews: some View {
        let data = CYWidgetDataLoader.getWidgetData(.calendar)
        CYWidgetCalendarView(entry: SimpleEntry(date: Date(), data: data))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
