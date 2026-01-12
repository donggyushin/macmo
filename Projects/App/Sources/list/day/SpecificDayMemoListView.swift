//
//  SpecificDayMemoListView.swift
//  macmo
//
//  Created by ratel on 1/12/26.
//

import SwiftUI

struct SpecificDayMemoListView: View {
    @StateObject var model: SpecificDayMemoListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager

    @Binding var present: Bool

    var body: some View {
        List {
            ForEach(model.memos, id: \.id) { memo in
                MemoRowView(memo: memo)
                    .tag(memo.id)
                    .onTapGesture {
                        navigationManager.push(.detail(memo.id))
                    }
            }
        }
        .task {
            try? model.fetchMemos()
        }
        .presentationDetents([.medium, .large])
    }
}

private struct SpecificDayMemoListViewPreview: View {
    @State private var present = false
    var body: some View {
        Button("Toggle") {
            present.toggle()
        }
        .onAppear {
            present = true
        }
        .sheet(isPresented: $present) {
            SpecificDayMemoListView(model: .init(date: Date()), present: $present)
        }
    }
}

#Preview {
    SpecificDayMemoListViewPreview()
        .preferredColorScheme(.dark)
}
