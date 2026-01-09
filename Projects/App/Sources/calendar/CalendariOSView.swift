//
//  CalendariOSView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendariOSView: View {
    @StateObject var model: CalendarViewModel

    var body: some View {
        Text("CalendariOSView")
    }
}

private struct CalendariOSViewPreview: View {
    var body: some View {
        CalendariOSView(model: .init(Date()))
    }
}

#Preview {
    CalendariOSViewPreview()
        .preferredColorScheme(.dark)
}
