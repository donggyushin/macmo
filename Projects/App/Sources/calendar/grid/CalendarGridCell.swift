//
//  CalendarGridCell.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarGridCell: View {
    let date: Date
    let today: Date

    init(date: Date, today: Date = Date()) {
        self.date = date
        self.today = today
    }

    var body: some View {
        Text("CalendarGridCell")
    }
}

private struct CalendarGridCellPreview: View {
    var body: some View {
        CalendarGridCell(date: Date())
    }
}

#Preview {
    CalendarGridCellPreview()
        .preferredColorScheme(.dark)
}
