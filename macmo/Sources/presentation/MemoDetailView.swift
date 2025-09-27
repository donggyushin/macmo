//
//  MemoDetailView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import SwiftUI

struct MemoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var model: MemoDetailViewModel

    init(model: MemoDetailViewModel) {
        _model = .init(initialValue: model)
    }

    var body: some View {
        
    }
}
