//
//  MacMonthCalendarView+Preview.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI

private struct MacMonthCalendarViewPreview: View {
    var body: some View {
        MacMonthCalendarView(model: .init(date: Date()))
            .frame(width: 900, height: 800)
            .padding()
    }
}

#Preview {
    MacMonthCalendarViewPreview()
        .preferredColorScheme(.dark)
}
