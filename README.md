# macmo

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

<img width="1680" height="1050" alt="Screenshot 2025-09-29 at 11 55 08 PM" src="https://github.com/user-attachments/assets/55a859d7-fa0d-4c8b-b46b-bee670865627" />

## Installation

### macOS

#### Quick Install (Recommended)

```bash
curl -L -O https://github.com/donggyushin/macmo/releases/latest/download/macmo.zip
unzip macmo.zip
mv macmo.app /Applications/
rm macmo.zip
echo "✅ macmo installed successfully!"
```

**First Launch Instructions:**

Since macmo is not distributed through the App Store, macOS will block it by default. Follow these steps to open it:

1. **Try to open the app** - Double-click `macmo.app` in Applications folder
2. **macOS will block it** - You'll see a message saying the app "cannot be opened because it is from an unidentified developer"
3. **Open System Settings** - Go to **System Settings → Privacy & Security**
4. **Allow the app** - Scroll down to find the security message about macmo and click **"Open Anyway"**
5. **Confirm** - Click **"Open"** in the confirmation dialog

Alternatively, you can **right-click (or Control-click) the app** and select **"Open"**, then click **"Open"** in the dialog.

> **Note**: You only need to do this once. After the first launch, you can open macmo normally.


#### Manual Install

1. Download the latest `macmo.zip` from [Releases](https://github.com/donggyushin/macmo/releases)
2. Unzip the file
3. Drag `macmo.app` to your Applications folder
4. **First launch only**: Follow the "First Launch Instructions" above to allow the app to run

### iOS / iPadOS

**Coming Soon to the App Store!**

The iOS version of macmo is currently in development and will be available on the App Store soon. The iOS app includes:

- 📱 **Native iOS interface** - Designed specifically for iPhone and iPad
- 🔄 **Seamless iCloud sync** - Your memos automatically sync between Mac, iPhone, and iPad
- 🎨 **iOS-optimized UI** - Large navigation titles, pull-to-refresh, and native gestures
- 🔍 **Smart search with animations** - Beautiful typing animations for quick filters
- 📅 **Calendar integration** - Sync memos with due dates to iOS Calendar

> **Note**: While the iOS app is pending App Store approval, you can build and install it yourself from source (see Development section below).

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
- [ ] App Store release for iOS
- [ ] iPad-optimized layout
- [ ] Widgets for iOS and macOS
- [ ] Shortcuts integration

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
