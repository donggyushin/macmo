# dgmemo

일정 기입은 맥으로, 확인은 아이폰으로 해보고 싶지 않으신가요? dgmemo에 일정, 생각나는 것, 업무 등 모든 것을 기록해보세요. 애플의 모든 디바이스와 연동됩니다. 

![macOS](https://img.shields.io/badge/macOS-15.0+-blue)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

✅ **Create, edit, and organize memos** - 간단하고 직관적인 메모(태스크) 관리 프로그램<br />
✅ **iCloud sync** - 모든 apple 디바이스에서 접근 가능한 설계<br />
✅ **Calendar integration** - 애플 캘린더와의 자동 연동<br />

## Screenshots

<img width="5840" height="3680" alt="Section 1" src="https://github.com/user-attachments/assets/9de1576f-5f94-4ff3-a942-f85a9d4f0a85" />

<img width="1222" height="511" alt="Screenshot 2026-01-17 at 12 46 33 PM" src="https://github.com/user-attachments/assets/b43d826a-2408-48e7-ae95-ac6fc0bb5bdc" />



## Installation

### macOS

**[💻 Download on the Mac App Store](https://apps.apple.com/kr/app/macmo/id6753157832)**

dgmemo의 macOS 버전은 현재 앱스토어에서 확인 가능합니다!

- 💻 **Native macOS interface** - macOS 가이드라인을 준수하여 깔끔한 디자인을 추구합니다.
- 🔄 **Seamless iCloud sync** - 당신의 모든 메모는 맥, 아이폰, 아이패드에서 데이터가 호환됩니다.
- 📅 **Calendar integration** - 캘린더와 자동으로 연동되는 데이터


### iOS / iPadOS

**[📱 Download on the App Store](https://apps.apple.com/kr/app/macmo/id6753157832)**

dgmemo의 iOS 버전은 현재 앱스토어에서 확인 가능합니다!

- 📱 **Native iOS interface** - 맥 버전의 디자인을 재활용하지 않았습니다. iPhone에 최적화된 디자인으로 따로 개발하였습니다.
- 🔄 **Seamless iCloud sync** - 당신의 모든 메모는 맥, 아이폰, 아이패드에서 데이터가 호환됩니다.
- 📅 **Calendar integration** - 캘린더와 자동으로 연동되는 데이터

### Calendar Integration
- **Automatic sync**: Due date를 설정하면 자동으로 애플 캘린더에 기입됩니다
- **Permission required**: 앱 첫 실행시 캘린더 접근에 동의해주세요
- **Smart updates**: 메모의 제목, 컨텐츠, 일정 변경에 따라서 자동으로 캘린더 데이터도 업데이트 됩니다

### Keyboard Shortcuts
- **⌘N** - New memo (opens in separate window)
- **Return** - Move from title to contents when editing


## Development

### Key Technologies
- **SwiftUI** - Modern UI framework
- **SwiftData** - Persistence with schema migration + CloudKit sync
- **EventKit** - Calendar integration for due date reminders
- **Factory** - Dependency injection framework
- **Tuist** - Project generation and dependency management
- **Fastlane** - Automated build and release pipeline


<img width="2784" height="2144" alt="image" src="https://github.com/user-attachments/assets/1b4c9d2f-1d5a-4d92-a214-2734beafbbcb" />


### DataBase
- CloudKit 데이터베이스를 사용해서 개발했습니다. Apple의 iCloud 기반으로 동작하기 때문에 보안적으로 취약하지 않고 애플 생태계의 모든 디바이스에서 자연스럽게 같은 데이터에 접근이 가능합니다. 또한 SwiftData를 이용해서 로컬 디비와의 자연스러운 호환 효과를 기대하고 간단하게 구현할 수 있습니다.

### MacmoDomain
의존성을 최대로 줄여 앱 외부의 변화로부터 영향을 받지 않게끔 설계합니다. 구현체는 모두 숨기고 행동만 정의하여 컨텍스트에 따라서 필요한 구현체들을 주입할 수 있게끔 전반적으로 앱을 설계합니다. 
- **Entity** - App 내에서 필요한 객체들의 모델을 정의합니다.
- **Repository** - 데이터에 접근합니다.
- **Service** - 캘린더, 푸쉬노티피케이션 등 외부 서비스와의 통합을 위해 정의합니다.
- **UseCase** - Repository와 Service들을 조합하여 하나의 완결된 비즈니스 로직을 수행합니다.

### MacmoData
실제 내부 데이터베이스 혹은 외부 서비스와 통합하여 데이터를 변경, 접근하는 행동에 대한 모든 구현을 담당합니다.

### App
가장 최상단 레이어로 실제 유저와 맞닿아있고 어플리케이션 그 자체입니다. 유저와의 상호작용이나 앱 수준의 이벤트등을 위임받고 동작합니다. 

### Dependencies Container
- Container 내부에 각 타입별로 의존성을 등록해줍니다. 이때에, 앱이 실행되는 context에 맞추어서 다른 구현체들을 주입해줄 수 있습니다. ViewModel 에서는 Container 를 통해 등록된 구현체들을 사용하면 생성자를 더럽히지 않으면서도 context 에 맞게 Impl 구현체, Mock 구현체 등을 알아서 주입받을 수 있게 되어서 Preview, Test 작성 등에 유리합니다.
- 의존성을 생성자를 통해서 직접 주입받지 않기 때문에 코드가 지저분해지고, 작은 변경 사항에도 code changes 가 많아지는 Dependency Drilling 을 방지해 줄 수 있습니다.
- 기존 코드가 Service Locator Pattern 을 준수하고 있다고 해서 앞으로의 코드 작성에 항상 @Injected annotation을 사용할 필요는 없습니다. 상황에 따라 필요하다면 유동적으로 의존성을 직접 주입받게 만들어줍니다. 

### NavigationManager
NavigationStack의 path에 직접 접근하여 앱의 네비게이팅을 관리해줍니다. App에서 EnvironmentObject로 등록해주기 때문에 Depth 가 깊은 컴포넌트들에서도 바로 직접 접근이 가능합니다. 

### iOSURLSchemeManager
앱과 그 어떠한 의존성도 생기지 않고 pure 한 String 값 만으로 앱의 네비게이션을 조작할 수 있게 도와줍니다. Widget, Push Notification, DeepLink 등 활용성이 매우 범용적입니다.

### Entity

#### Memo
앱의 핵심 도메인 모델입니다. 사용자가 작성하는 메모(태스크)의 모든 정보를 담고 있습니다.

| 프로퍼티 | 타입 | 설명 |
|---------|------|------|
| `id` | String | 고유 식별자 |
| `title` | String | 메모 제목 |
| `contents` | String? | 메모 내용 (마크다운 지원) |
| `due` | Date? | 마감일 |
| `done` | Bool | 완료 여부 |
| `eventIdentifier` | String? | 연동된 캘린더 이벤트 ID |
| `createdAt` | Date | 생성일 |
| `updatedAt` | Date | 수정일 |
| `images` | [ImageAttachment] | 첨부 이미지 목록 |

**Computed Properties:**
- `isUrgent` - 마감일이 3일 이내이고 미완료인 경우 `true`
- `isOverDue` - 마감일이 지난 경우 `true`

#### CalendarDay
캘린더 뷰에서 특정 날짜에 메모를 매핑하기 위한 모델입니다.

| 프로퍼티 | 타입 | 설명 |
|---------|------|------|
| `year` | Int | 연도 |
| `month` | Int | 월 |
| `day` | Int | 일 |
| `memo` | Memo | 해당 날짜의 메모 |

### Repository

#### UserPreferenceRepository
사용자 설정 및 앱 상태를 저장하고 불러오는 인터페이스입니다. UserDefaults를 통해 영속화됩니다.

| 메서드 | 설명 |
|--------|------|
| `getMemoSort()` / `setMemoSort(_:)` | 메모 정렬 기준 (생성일/수정일/마감일) |
| `getAscending()` / `setAscending(_:)` | 정렬 순서 (오름차순/내림차순) |
| `getStatistics()` / `setStatistics(_:)` | 통계 뷰 타입 |
| `getMemoSortCacheInSearch()` / `setMemoSortCacheInSearch(_:)` | 검색 화면 정렬 기준 캐시 |
| `getMemoSearchQuery()` / `setMemoSearchQuery(_:)` | 검색어 캐시 |
| `getSelectedMemoId()` / `setSelectedMemoId(_:)` | 선택된 메모 ID |
| `getMemoDraft()` / `setMemoDraft(_:)` | 작성 중인 메모 임시 저장 |
| `getAppTabEnum()` / `setAppTabEnum(_:)` | 현재 선택된 탭 |
| `getCalendarDotVisibleMode()` / `setCalendarDotVisibleMode(_:)` | 캘린더 dot 표시 모드 |

#### MemoRepository
메모 데이터의 CRUD 및 조회를 담당하는 인터페이스입니다. SwiftData를 통해 영속화되며, iCloud를 통해 기기 간 동기화됩니다.


### Prerequisites
- Xcode 26.0+
- Tuist 4.0+
- macOS 15.0+

### Setup
```bash
# Clone the repository
git clone https://github.com/donggyushin/macmo.git
cd macmo

# Generate Xcode project
tuist generate

# Open in Xcode
open macmo.xcworkspace
```

### Building for Release
```bash
tuist generate
[bundle exec] fastlane mac release
[bundle exec] fastlane ios release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Security & Privacy

- **Local storage** - All data stored locally on your device
- **iCloud sync** - Data synced through your personal iCloud account
- **Calendar privacy** - Calendar access only used for syncing your memos, no data sharing
- **No tracking** - No analytics or user tracking
- **Open source** - Full source code available for review


## Support

- **Issues** - [GitHub Issues](https://github.com/donggyushin/macmo/issues)
- **Discussions** - [GitHub Discussions](https://github.com/donggyushin/macmo/discussions)

## Author

**Donggyu Shin** - [@donggyushin](https://github.com/donggyushin)

---

⭐ **Star this repository if you found it helpful!** ⭐
