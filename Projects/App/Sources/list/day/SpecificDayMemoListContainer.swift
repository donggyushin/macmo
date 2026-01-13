//
//  SpecificDayMemoListContainer.swift
//  macmo
//
//  Created by ratel on 1/12/26.
//

import SwiftUI

struct SpecificDayMemoListContainer: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var model: SpecificDayMemoListContainerModel
    @Binding var present: Bool

    var selectedDateChanged: ((Date) -> Void)?
    func selectedDateChanged(_ action: ((Date) -> Void)?) -> Self {
        var copy = self
        copy.selectedDateChanged = action
        return copy
    }

    init(model: SpecificDayMemoListContainerModel, present: Binding<Bool>) {
        _model = .init(wrappedValue: model)
        _present = present
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $model.selectedDate) {
                ForEach(model.dates, id: \.self) { date in
                    SpecificDayMemoListView(model: .init(date: date), present: $present)
                        .tag(date)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationTitle(formattedDate(date: model.selectedDate))
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            present = false
                            try await Task.sleep(for: .seconds(0.7))
                            navigationManager.push(.detail(nil, model.date))
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .onAppear {
            guard let firstDate = model.dates.first else { return }
            guard let lastDate = model.dates.last else { return }
            model.fetchPrevDates(date: firstDate)
            model.fetchNextDates(date: lastDate)
        }
        .onChange(of: model.selectedDate) {
            selectedDateChanged?(model.selectedDate)
            guard model.dates.count > 3 else { return }
            let selectedDate = model.selectedDate

            if selectedDate == model.dates.first {
                model.fetchPrevDates(date: selectedDate)
            }

            if selectedDate == model.dates.last {
                model.fetchNextDates(date: selectedDate)
            }
        }
    }

    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

private struct SpecificDayMemoListContainerPreview: View {
    @State private var present = false

    var body: some View {
        Button("Toggle") {
            present.toggle()
        }
        .onAppear {
            present = true
        }
        .sheet(isPresented: $present) {
            SpecificDayMemoListContainer(model: .init(date: Date()), present: $present)
        }
    }
}

#Preview {
    SpecificDayMemoListContainerPreview()
        .preferredColorScheme(.dark)
}
