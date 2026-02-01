//
//  MacMonthCalendarListView.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI

struct MacMonthCalendarListView: View {
    @StateObject var model: MacMonthCalendarListViewModel

    // selectedDate 를 이용해서 MacMonthCalendarView 를 그림.
    // 유저가 상호작용을 통해서 저번달, 다음달로 캘린더 이동 가능.
    // 더 이상 이동할 수 없을때 fetchLeft, fetchRight 함수를 동적으로 호출해서 동적으로 데이터 준비
    var body: some View {
        Text("MacMonthCalendarListView")
    }
}
