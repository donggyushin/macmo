import SwiftUI

struct SortingPicker: View {
    @Binding var sortBy: MemoSort

    var body: some View {
        Picker("Sort by", selection: $sortBy) {
            Text("Created").tag(MemoSort.createdAt)
            Text("Updated").tag(MemoSort.updatedAt)
            Text("Due").tag(MemoSort.due)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
