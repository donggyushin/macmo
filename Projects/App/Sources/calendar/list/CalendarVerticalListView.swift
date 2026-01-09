//
//  CalendarVerticalListView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarVerticalListView: View {
    @StateObject var model: CalendarVerticalListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(model.dates, id: \.self) { date in
                    CalendarView(model: .init(date))
                }
            }
        }
        .onAppear {
            model.fetchNextDates(date: model.dates.last)
            model.fetchPrevDates(date: model.dates.first)
        }
    }
}

#Preview {
    CalendarVerticalListView(model: .init())
        .preferredColorScheme(.dark)
}
