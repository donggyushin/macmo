//
//  MacMonthCalendarListView+Preview.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

#if os(macOS)
import SwiftUI

struct MacMonthCalendarListViewPreview: View {
    var body: some View {
        MacMonthCalendarListView(model: .init(date: Date()))
    }
}

#Preview {
    MacMonthCalendarListViewPreview()
        .preferredColorScheme(.dark)
}
#endif
