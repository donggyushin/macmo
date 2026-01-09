//
//  CalendarGridCell.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarGridCell: View {
    let today: Date
    let calendarUtility: CalendarUtility

    @State private var gridCells: [Int?] = []

    init(date: Date, today: Date = Date()) {
        self.today = today
        self.calendarUtility = .init(date: date)
    }

    var body: some View {
        VStack {
            Text("\(String(calendarUtility.month))월")
            // 아주 작은 calendar 모양 grid cells
        }
        .onAppear {
            gridCells = calendarUtility.gridCells
        }
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
