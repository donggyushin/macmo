# macmo

A clean, simple memo application for macOS with iCloud sync.

![macOS](https://img.shields.io/badge/macOS-15.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

✅ **Create, edit, and organize memos** - Simple and intuitive memo management
✅ **iCloud sync** - Access your memos across all Apple devices
✅ **Smart sorting** - Sort by creation date, update date, or due date
✅ **Due date management** - Set due dates with overdue indicators
✅ **Task completion** - Mark memos as completed with visual feedback
✅ **Native macOS interface** - Clean design that follows macOS guidelines
✅ **Multi-window support** - Open new memos in separate windows
✅ **Context menus** - Right-click for quick actions

## Screenshots

*Coming soon - screenshots of the app in action*

## Installation

### Quick Install (Recommended)

```bash
curl -L -O https://github.com/donggyushin/macmo/releases/latest/download/macmo-v1.1.0.zip
unzip macmo-v1.1.0.zip
mv macmo.app /Applications/
rm macmo-v1.1.0.zip
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

### iCloud Sync
- Sign into iCloud on your devices with the same Apple ID
- Memos automatically sync across iPhone, iPad, and Mac
- Works offline - syncs when internet is available

### Keyboard Shortcuts
- **⌘N** - New memo (opens in separate window)
- **Return** - Move from title to contents when editing
- **Delete** - Delete selected memo

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

- [ ] Export memos to Markdown/PDF
- [ ] Search and filtering
- [ ] Tags and categories
- [ ] Rich text formatting
- [ ] Attachments support
- [ ] Sharing capabilities

## Security & Privacy

- **Local storage** - All data stored locally on your device
- **iCloud sync** - Data synced through your personal iCloud account
- **No tracking** - No analytics or user tracking
- **Open source** - Full source code available for review

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues** - [GitHub Issues](https://github.com/donggyushin/macmo/issues)
- **Discussions** - [GitHub Discussions](https://github.com/donggyushin/macmo/discussions)

## Author

**Donggyu Shin** - [@donggyushin](https://github.com/donggyushin)

---

⭐ **Star this repository if you found it helpful!** ⭐
