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
        NavigationStack {
            Group {
                if model.memos.isEmpty {
                    // Empty State
                    ContentUnavailableView {
                        Label("No Memos", systemImage: "note.text")
                    } description: {
                        Text("No memos for this date.\nTap the + button to add one.")
                    }
                } else {
                    // Memo List
                    List {
                        ForEach(model.memos, id: \.id) { memo in
                            MemoRowView(memo: memo)
                                .tag(memo.id)
                                .onTapGesture {
                                    Task {
                                        present = false
                                        try await Task.sleep(for: .seconds(0.7))
                                        navigationManager.push(.detail(memo.id, nil))
                                    }
                                }
                        }
                    }
                }
            }
            .task {
                try? model.fetchMemos()
            }
            .presentationDetents([.medium, .large])
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            present = false
                            try await Task.sleep(for: .seconds(0.7))
                            navigationManager.push(.detail(nil, nil))
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
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
