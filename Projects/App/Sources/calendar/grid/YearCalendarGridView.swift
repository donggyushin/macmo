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
        Text("YearCalendarGridView")
    }
}

#Preview {
    YearCalendarGridView(model: .init(date: Date()))
        .preferredColorScheme(.dark)
}
