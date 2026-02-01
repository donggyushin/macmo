//
//  MacMonthCalendarView.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI

struct MacMonthCalendarView: View {
    @StateObject var model: MacMonthCalendarViewModel

    var body: some View {
        Text("MacMonthCalendarView")
    }
}

private struct MacMonthCalendarViewPreview: View {
    var body: some View {
        MacMonthCalendarView(model: .init(date: Date()))
    }
}

#Preview {
    MacMonthCalendarViewPreview()
        .preferredColorScheme(.dark)
}
