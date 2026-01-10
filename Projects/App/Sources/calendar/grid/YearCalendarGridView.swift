//
//  YearCalendarGridView.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import SwiftUI

struct YearCalendarGridView: View {
    @StateObject var model: YearCalendarGridViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("\(String(model.year))")
                .font(.title)
                .fontWeight(.bold)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(model.monthDates, id: \.self) { date in
                    CalendarGridCell(date: date, today: model.today)
                }
            }
        }
        .padding()
    }
}

#Preview {
    YearCalendarGridView(model: .init(date: Date()))
        .preferredColorScheme(.dark)
}
