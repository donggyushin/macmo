//
//  YearCalendarGridView.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import SwiftUI

// This is for iOS
struct YearCalendarGridView: View {
    @StateObject var model: YearCalendarGridViewModel

    var tapCalendar: ((Date) -> Void)?
    func tapCalendar(_ action: ((Date) -> Void)?) -> Self {
        var copy = self
        copy.tapCalendar = action
        return copy
    }

    var body: some View {
        VStack(spacing: 26) {
            HStack {
                Text("\(String(model.year))")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(model.monthDates, id: \.self) { date in
                    Button {
                        tapCalendar?(date)
                    } label: {
                        CalendarGridCell(date: date, today: model.today)
                    }
                    .buttonStyle(.plain)
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
