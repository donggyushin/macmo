# dgmemo

A clean, simple memo application for macOS and iOS with iCloud sync.

![macOS](https://img.shields.io/badge/macOS-15.0+-blue)
![iOS](https://img.shields.io/badge/iOS-18.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

✅ **Create, edit, and organize memos** - Simple and intuitive memo management<br />
✅ **iCloud sync** - Access your memos across all Apple devices<br />
✅ **Calendar integration** - Automatically sync memos with due dates to macOS Calendar<br />
✅ **Smart sorting** - Sort by creation date, update date, or due date<br />
✅ **Due date management** - Set due dates with overdue indicators<br />
✅ **Task completion** - Mark memos as completed with visual feedback<br />
✅ **Smart search** - Search with special filters: "urgent" for due-soon memos, "completed" for done tasks<br />
✅ **Native macOS interface** - Clean design that follows macOS guidelines<br />
✅ **Multi-window support** - Open new memos in separate windows<br />
✅ **Context menus** - Right-click for quick actions<br />

## Screenshots

<img width="1680" height="1050" alt="Screenshot 2025-10-04 at 12 07 37 AM" src="https://github.com/user-attachments/assets/d1e6918f-2dbf-4040-91ed-563370444f8a" />

<img width="1332" height="960" alt="image" src="https://github.com/user-attachments/assets/ee4b42a9-13b6-42d3-ba0e-8967590b90fd" />


## Installation

### macOS

**[💻 Download on the Mac App Store](https://apps.apple.com/kr/app/macmo/id6753157832)**

The macOS version of dgmemo is now available on the App Store! The Mac app includes:

- 💻 **Native macOS interface** - Clean design that follows macOS guidelines
- 🔄 **Seamless iCloud sync** - Your memos automatically sync between Mac, iPhone, and iPad
- 🪟 **Multi-window support** - Open new memos in separate windows
- 📅 **Calendar integration** - Automatically sync memos with due dates to macOS Calendar
- ⌨️ **Keyboard shortcuts** - Quick access with ⌘N for new memos
- 🎯 **Context menus** - Right-click for quick actions

### iOS / iPadOS

**[📱 Download on the App Store](https://apps.apple.com/kr/app/macmo/id6753157832)**

The iOS version of dgmemo is now available! The iOS app includes:

- 📱 **Native iOS interface** - Designed specifically for iPhone and iPad
- 🔄 **Seamless iCloud sync** - Your memos automatically sync between Mac, iPhone, and iPad
- 🎨 **iOS-optimized UI** - Large navigation titles, pull-to-refresh, and native gestures
- 🔍 **Smart search with animations** - Beautiful typing animations for quick filters
- 📅 **Calendar integration** - Sync memos with due dates to iOS Calendar

## Requirements

- **macOS 15.0+** for Mac app
- **iOS 18.0+** for iPhone/iPad app
- **iCloud account** for sync across devices (optional but recommended)

## Usage

### Basic Operations
- **Create memo**: Click the "Add" button or use ⌘N
- **Edit memo**: Click on any memo to view/edit in the detail pane
- **Delete memo**: Right-click on a memo and select "Delete"
- **Sort memos**: Use the sorting picker to organize by date
- **Search memos**: Use the search bar with special keywords:
  - Type "urgent" to find memos due within 3 days (excluding completed ones)
  - Type "completed" to find all finished memos
  - Regular text search works for title and content

### iCloud Sync
- Sign into iCloud on your devices with the same Apple ID
- Memos automatically sync across iPhone, iPad, and Mac
- Works offline - syncs when internet is available

### Calendar Integration
- **Automatic sync**: Memos with due dates are automatically added to your macOS Calendar
- **Permission required**: On first launch, grant calendar access when prompted
- **Smart updates**: Calendar events update automatically when you edit memo titles, contents, or due dates
- **Auto cleanup**: Deleting a memo or removing its due date also removes the calendar event
- **Event details**: Calendar events include memo title and contents with 1-hour duration

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
- Xcode 15.0+
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

## Roadmap

- [x] Markdown support
- [x] Search and filtering
- [x] Calendar integration
- [ ] Tags and categories
- [x] Rich text formatting
- [x] iOS/iPadOS native application
- [x] App Store release for iOS
- [x] App Store release for macOS
- [x] iPad-optimized layout
- [x] Widget for iOS
- [ ] Widget for macOS

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
