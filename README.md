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

<img width="1680" height="1050" alt="Screenshot 2025-10-04 at 12 07 37 AM" src="https://github.com/user-attachments/assets/d1e6918f-2dbf-4040-91ed-563370444f8a" />

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
