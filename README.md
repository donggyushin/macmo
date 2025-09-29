# macmo

A clean, simple memo application for macOS with iCloud sync.

![macOS](https://img.shields.io/badge/macOS-15.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

✅ **Create, edit, and organize memos** - Simple and intuitive memo management<br />
✅ **iCloud sync** - Access your memos across all Apple devices<br />
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

### Quick Install (Recommended)

```bash
curl -L -O https://github.com/donggyushin/macmo/releases/latest/download/macmo.zip
unzip macmo.zip
mv macmo.app /Applications/
rm macmo.zip
echo "✅ macmo installed successfully!"
```

### Manual Install

1. Download the latest `macmo.zip` from [Releases](https://github.com/donggyushin/macmo/releases)
2. Unzip the file
3. Drag `macmo.app` to your Applications folder
4. Right-click the app and select "Open" (first time only)

## Requirements

- **macOS 15.0** or later
- **iCloud account** for sync (optional but recommended)

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

### Keyboard Shortcuts
- **⌘N** - New memo (opens in separate window)
- **Return** - Move from title to contents when editing

## Architecture

This project follows clean architecture principles:

- **Domain Layer** - Pure business logic with `Memo` entities
- **Service Layer** - Data persistence with SwiftData + CloudKit
- **Presentation Layer** - SwiftUI views with MVVM pattern

### Key Technologies
- **SwiftUI** - Modern UI framework
- **SwiftData** - Apple's latest persistence framework
- **CloudKit** - iCloud integration for sync
- **Tuist** - Project generation and dependency management
- **Factory** - Dependency injection framework

## Development

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

### Project Structure
```
macmo/Sources/
├── domain/          # Core business logic
│   ├── model/       # Domain entities (Memo)
│   └── dao/         # Data access protocols
├── service/         # Infrastructure layer
│   ├── dao/         # DAO implementations
│   └── dto/         # SwiftData models
└── presentation/    # UI layer
    ├── store/       # State management
    └── *.swift      # SwiftUI views
```

### Building for Release
```bash
tuist generate
xcodebuild -workspace macmo.xcworkspace -scheme macmo -configuration Release -derivedDataPath ./build
```

### zip command
```bash
zip -r archive_name.zip folder_name/
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Roadmap

- [x] Markdown
- [x] Search and filtering
- [ ] Tags and categories
- [x] Rich text formatting
- [ ] Release iOS mobile application sharing data through iCloud

## Security & Privacy

- **Local storage** - All data stored locally on your device
- **iCloud sync** - Data synced through your personal iCloud account
- **No tracking** - No analytics or user tracking
- **Open source** - Full source code available for review


## Support

- **Issues** - [GitHub Issues](https://github.com/donggyushin/macmo/issues)
- **Discussions** - [GitHub Discussions](https://github.com/donggyushin/macmo/discussions)

## Author

**Donggyu Shin** - [@donggyushin](https://github.com/donggyushin)

---

⭐ **Star this repository if you found it helpful!** ⭐
