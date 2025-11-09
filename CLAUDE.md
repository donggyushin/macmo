# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **macOS SwiftUI memo application** built with **Tuist micro-projects architecture** and SwiftData, following Domain-Driven Design principles with strict modular boundaries.

## Essential Development Commands

### Project Generation and Building
```bash
# Generate Xcode workspace from Tuist configuration
tuist generate

# Generate and immediately open in Xcode
tuist generate --open

# Clean build artifacts
tuist clean

# Run tests
tuist test

# Edit project configuration in temporary project
tuist edit
```

### Testing
```bash
# Run all tests via Tuist (recommended)
tuist test

# Or run tests through xcodebuild directly
xcodebuild test -workspace macmo.xcworkspace -scheme macmo-Workspace -destination 'platform=macOS'
```

### Dependency Management
```bash
# Install/update dependencies (handled automatically by Tuist)
tuist generate  # Re-generates with latest dependency versions

# Check dependency resolution
cat .package.resolved
```

## Modular Architecture

### Project Structure Overview
This is a **Tuist-managed modular macOS SwiftUI application** using **micro-projects architecture** with three independent framework modules following **Domain-Driven Design (DDD)** and **Clean Architecture** patterns:

```
macmo/
├── Workspace.swift                     # Workspace definition
├── Project.swift.backup                # Backup of original single-target config
├── Tuist/
│   └── ProjectDescriptionHelpers/
│       └── Project+Templates.swift     # Shared settings and helpers
└── Projects/
    ├── Domain/                         # MacmoDomain framework
    │   ├── Project.swift
    │   └── Sources/
    │       ├── entity/                 # Domain entities
    │       ├── repository/             # Repository protocols
    │       ├── service/                # Service protocols
    │       └── usecase/                # Use cases
    ├── Data/                           # MacmoData framework
    │   ├── Project.swift
    │   └── Sources/
    │       ├── dao/                    # Data Access Objects
    │       ├── dto/                    # Data Transfer Objects
    │       ├── repository/             # Repository implementations
    │       └── service/                # Service implementations
    └── App/                            # macmo application target
        ├── Project.swift
        ├── macmo.entitlements          # App entitlements
        ├── Sources/                    # App UI and ViewModels
        ├── Resources/                  # Assets and resources
        ├── Tests/                      # Unit tests
        └── Widget/                     # Widget extension
```

### Module Dependencies

```
MacmoDomain (pure Swift, no dependencies)
    ↑
MacmoData (depends on MacmoDomain)
    ↑
App (depends on MacmoDomain + MacmoData)
```

**Strict Dependency Rules:**
- `MacmoDomain`: No dependencies, pure business logic
- `MacmoData`: Depends only on `MacmoDomain`
- `App`: Depends on both `MacmoDomain` and `MacmoData`

### Module Import Convention

**IMPORTANT:** Due to naming conflicts with Foundation types, modules are prefixed:
- Use `import MacmoDomain` (NOT `import Domain`)
- Use `import MacmoData` (NOT `import Data`)

### Key Architectural Patterns

#### 1. Micro-Projects Architecture
This project uses **Tuist micro-projects** for strong module isolation:

**Benefits:**
- **Build caching**: Unchanged modules aren't rebuilt
- **Strict boundaries**: Compiler-enforced dependency rules
- **Parallel development**: Teams can work on different modules independently
- **Reusability**: Modules can be shared across targets (e.g., iOS app)

**Project Configuration:**
- `Workspace.swift`: Defines workspace and project relationships
- `ProjectDescriptionHelpers/`: Shared Tuist configuration and helpers
- Each module has its own `Project.swift` with independent settings

#### 2. Domain-Driven Design Layer Separation

**MacmoDomain Module** (Pure business logic):
- **Entities** (`entity/`): Core domain models
  - `Memo.swift`: Core domain entity with business rules
  - `MemoSort.swift`: Sorting strategy enumeration
  - `AppError.swift`: Domain error types
  - `CalendarServiceError.swift`: Calendar-specific errors
  - `MemoStatistics.swift`: Statistics models
  - `NavigationDomain.swift`: Navigation state
  - `StatisticsEnum.swift`: Statistics view types

- **Repository Protocols** (`repository/`): Data access interfaces
  - `MemoRepository.swift`: Repository interface defining CRUD + sorting operations
  - `UserPreferenceRepository.swift`: User preferences interface

- **Service Protocols** (`service/`): External service interfaces
  - `CalendarService.swift`: Calendar integration protocol
  - `NavigationService.swift`: Navigation state protocol

- **Use Cases** (`usecase/`): Business logic orchestration
  - `MemoUseCase.swift`: Coordinates memo operations with calendar sync

**MacmoData Module** (Infrastructure implementations):
- **DAO** (`dao/`): Low-level data access
  - `MemoDAO.swift`: DAO protocol for persistence operations
  - `MemoDAOImpl.swift`: SwiftData-based DAO implementation
  - `MemoDAOMock.swift`: In-memory DAO for testing/development

- **Repository** (`repository/`): Repository pattern implementations
  - `MemoRepositoryImpl.swift`: Implements MemoRepository, delegates to DAO + caching
  - `UserPreferenceRepositoryImpl.swift`: UserDefaults-based preferences
  - `UserPreferenceRepositoryMock.swift`: Mock for testing

- **DTO** (`dto/`): Data Transfer Objects
  - `MemoDTO.swift`: SwiftData model with domain mapping methods

- **Services** (`service/`): External service implementations
  - `CalendarServiceImpl.swift`: EventKit-based calendar integration
  - `CalendarServiceMock.swift`: Mock calendar service for testing
  - `NavigationServiceImpl.swift`: Navigation state service

- **Infrastructure** (`/`): Shared utilities
  - `UserDefaultPropertyWrapper.swift`: Property wrapper for UserDefaults

**App Module** (UI and app configuration):
- `MacmoApp.swift`: App entry point with SwiftData configuration
- `Dependencies.swift`: Factory DI configuration for all dependencies
- `ContentView.swift`: Main split view layout
- ViewModels: `MemoDetailViewModel`, `MemoListViewModel`, `SearchMemoViewModel`, `SettingViewModel`
- Views organized by feature:
  - `components/`: Reusable UI components
  - `detail/`: Memo detail views
  - `list/`: Memo list views
  - `search/`: Search views
  - `setting/`: Settings views
  - `navigation/`: Navigation management
- `Tests/`: Unit tests for repositories and use cases
- `Widget/`: Widget extension sources

#### 3. Repository Pattern with DAO Abstraction
The codebase implements a **multi-layered Repository pattern**:

**Three-Layer Data Access Architecture:**
1. **Repository Layer** (Domain interface → Data implementation)
   - **Protocol**: `MemoRepository` (in `MacmoDomain/repository/`)
   - **Implementation**: `MemoRepositoryImpl` (in `MacmoData/repository/`)
   - **Responsibilities**: User preferences caching (sort order, ascending), delegates persistence to DAO

2. **DAO Layer** (Low-level persistence abstraction)
   - **Protocol**: `MemoDAO` (in `MacmoData/dao/`)
   - **Production**: `MemoDAOImpl` - SwiftData persistence
   - **Mock**: `MemoDAOMock` - In-memory storage with sample data
   - **Responsibilities**: Direct database operations (CRUD, search, pagination)

3. **Use Case Layer** (Business logic orchestration)
   - **Implementation**: `MemoUseCase` (in `MacmoDomain/usecase/`)
   - **Responsibilities**: Coordinates memo operations with calendar service integration
   - **Pattern**: Uses Repository (for data access) and CalendarService (for calendar sync)

**Key Design Decisions:**
- **Repository wraps DAO**: Repository adds caching layer (UserDefaults for sort preferences) on top of DAO
- **UseCase orchestrates**: Combines multiple services (Repository + CalendarService) for complex operations
- **Proper layering**: UseCase depends on Repository (not DAO), maintaining clean architecture boundaries
- **Domain-DTO Mapping**: Explicit `toDomain()` and `fromDomain()` methods
- **Protocol-first**: Every implementation has a corresponding protocol in the domain layer

#### 4. Dependency Injection with Factory
- **Factory Framework**: Fully integrated Factory DI framework (v2.5.3)
- **Configured in**: `App/Sources/Dependencies.swift`
- **Injection Hierarchy**:
  - `ModelContainer` → `ModelContext` (SwiftData setup)
  - `MemoDAO` (production: `MemoDAOImpl`, preview: `MemoDAOMock`)
  - `MemoRepository` (wraps `MemoDAO`)
  - `CalendarService` (production: `CalendarServiceImpl`, preview: `CalendarServiceMock`)
  - `MemoUseCase` (combines `MemoRepository` + `CalendarService`)
- **Usage Pattern**: `@Injected(\.memoUseCase)` in ViewModels, `@Injected(\.memoRepository)` when direct repository access needed

### Key Dependencies

#### Core Frameworks
- **SwiftUI**: UI framework for macOS application
- **SwiftData**: Apple's modern data persistence framework with schema migration
- **EventKit**: Calendar integration for due date reminders
- **Foundation**: Core Swift framework

#### External Dependencies
- **Factory** (v2.5.3): Dependency injection framework by @hmlongco
  - Fully integrated in `App/Sources/Dependencies.swift`
  - Used throughout the app for injecting use cases, repositories, DAOs, and services

- **MarkdownUI** (v2.4.0): Markdown rendering in SwiftUI
  - Used for memo content display

#### Development Tools
- **Tuist** (v4.68.0): Micro-projects architecture and build system management
- **mise**: Tool version management (specified in `mise.toml`)
- **Fastlane**: Automated build and release pipeline

## Important Conventions & Patterns

### Module Access Control
**CRITICAL:** All types, properties, methods, and initializers that need to be accessed from other modules MUST be declared `public`:

```swift
// In MacmoDomain
public protocol MemoRepository {
    public func save(_ memo: Memo) throws
}

public struct Memo {
    public let id: String
    public init(id: String, ...) { ... }
}

// In MacmoData
public final class MemoRepositoryImpl: MemoRepository {
    public init(memoDAO: MemoDAO) { ... }
    public func save(_ memo: Memo) throws { ... }
}
```

**Common Mistakes:**
- Forgetting `public` on initializers
- Forgetting `public` on protocol requirements
- Forgetting `public` on static factory methods (e.g., `withSampleData()`)

### File Organization Rules
1. **Domain purity**: MacmoDomain contains only protocols, entities, and use cases - no framework dependencies
2. **Data layer isolation**: All infrastructure concerns (persistence, external services) live in MacmoData
3. **DTO-Domain separation**: Clear mapping between SwiftData DTOs and domain models
4. **Protocol-first design**: All data access and services go through protocol interfaces defined in MacmoDomain
5. **Sample data patterns**: Mock implementations include realistic sample data via static factory methods

### Layered Architecture Patterns
- **MacmoDomain**: Pure business logic, no external dependencies
  - Protocols define contracts
  - Entities define business objects
  - Use cases orchestrate business operations

- **MacmoData**: Infrastructure implementations
  - DAOs handle low-level persistence
  - Repositories add caching/preferences on top of DAOs
  - Services implement external integrations (Calendar, etc.)
  - DTOs for SwiftData persistence models

- **App**: UI and user interaction
  - Views (SwiftUI) organized by feature
  - ViewModels (business logic for views)
  - Navigation management (NavigationManager)
  - App configuration (MacmoApp, Dependencies)
  - Reusable UI components

### Persistence Patterns
- **SwiftData Integration**: Uses `@Model` macro for DTOs with `@Attribute(.unique)` for IDs
- **Domain Mapping**: Explicit `toDomain()` and `fromDomain()` methods for DTO-Domain conversion
- **Error Handling**: All DAO and repository methods throw for proper error propagation
- **Cursor Pagination**: Supports cursor-based pagination with configurable limit
- **Sorting**: Three sort modes (createdAt, updatedAt, due) with ascending/descending order

### Service Integration Patterns
- **Calendar Service**: EventKit integration for syncing memos with due dates
  - Auto-creates calendar events when memo has due date
  - Updates events when memo changes
  - Removes events when memo deleted or due date removed
  - Stores `eventIdentifier` in memo for tracking
- **Use Case Pattern**: `MemoUseCase` coordinates Repository + CalendarService operations
- **Error Handling**: Graceful degradation if calendar access denied

### Testing & Preview Patterns
- **Mock Implementations**: Dedicated mock classes for DAOs and services
- **Factory Preview Switching**: `.onPreview { MockImplementation }` for SwiftUI previews
- **Static Factories**: `MemoDAOMock.withSampleData()` for consistent test data
- **Protocol Testing**: Tests target protocol interfaces rather than concrete implementations
- **Test Location**: All tests live in `Projects/App/Tests/`
- **Test Dependencies**: Tests depend on macmo app target + MacmoDomain + MacmoData

### Development Workflow
1. Always run `tuist generate` after making Tuist configuration changes
2. Use `tuist test` to run all tests
3. Use mock implementations for SwiftUI previews (automatically via Factory)
4. MacmoDomain should remain framework-agnostic (protocols and entities only)
5. Infrastructure implementations go in MacmoData module
6. Use cases coordinate between multiple services
7. Repositories add caching/preferences on top of DAOs

## Current Implementation Status

### ✅ Fully Implemented
- **MacmoDomain Module**:
  - Complete domain entities (`Memo`, `MemoSort`, `CalendarServiceError`, `AppError`, etc.)
  - Repository protocols (`MemoRepository`, `UserPreferenceRepository`)
  - Service protocols (`CalendarService`, `NavigationService`)
  - Use cases (`MemoUseCase` with calendar integration)

- **MacmoData Module**:
  - DAO layer with protocol and implementations (`MemoDAO`, `MemoDAOImpl`, `MemoDAOMock`)
  - Repository implementations (`MemoRepositoryImpl`, `UserPreferenceRepositoryImpl`)
  - SwiftData persistence with DTO mapping (`MemoDTO`)
  - Calendar service integration (`CalendarServiceImpl`, `CalendarServiceMock`)
  - Navigation service (`NavigationServiceImpl`)

- **App Module**:
  - Complete MVVM pattern with ViewModels
  - Navigation management (`NavigationManager`)
  - Full UI implementation:
    - Split view navigation with list and detail (`ContentView`)
    - Search functionality with special filters (`SearchMemoView`, `SearchMemoViewModel`)
    - Multi-window support for new memos
    - Context menu operations
    - Due date management with overdue indicators
    - Task completion tracking
    - iOS-specific views (`iOSMemoListView`, `iOSSearchMemoView`)
    - Settings screen with developer options (`SettingView`, `DeveloperView`, `LicenseView`)
  - Comprehensive test suite:
    - `MemoRepositoryTests.swift`: 11 tests for repository layer
    - `MemoUseCaseTests.swift`: 10 tests for use case layer with calendar integration
    - `MarkdownListContinuationTests.swift`: Markdown formatting tests

- **Infrastructure**:
  - Tuist micro-projects architecture
  - Factory dependency injection fully configured
  - SwiftData + CloudKit integration
  - EventKit calendar integration
  - Cursor-based pagination
  - Three-way sorting (created/updated/due)
  - Real-time UI updates
  - Widget extension support

## macOS-Specific Features

### Navigation Structure
- **NavigationSplitView**: Main app uses split view with sidebar (memo list) and detail pane
- **Window Management**: New memo creation opens in separate windows using `openWindow(id: "memo-detail")`
- **Window Dismissal**: New memo windows auto-close after saving using `dismissWindow(id: "memo-detail")`

### User Interactions
- **Context Menus**: Right-click on memo rows for delete/actions (`.contextMenu`)
- **List Selection**: Single memo selection updates detail view automatically
- **Keyboard Shortcuts**: Standard macOS delete key behavior with `.onDelete`
- **Toolbar Actions**: Platform-appropriate toolbar button placement

### UI Patterns
- **No NavigationView**: Uses NavigationSplitView instead (NavigationView is iOS-focused)
- **No .navigationBarTitleDisplayMode**: This modifier is iOS-only, removed for macOS
- **TextEditor Styling**: Custom padding and transparent background for better macOS appearance
- **Window Sizing**: Default window sizes specified in WindowGroup (.defaultSize)

### Architecture Summary

#### Micro-Projects Clean Architecture
1. **MacmoDomain Module**: Business logic core
   - Protocols for all external contracts
   - Pure entities with no framework dependencies
   - Use cases for orchestrating business operations

2. **MacmoData Module**: Infrastructure implementations
   - DAO pattern for persistence abstraction
   - Repository pattern for caching + DAO delegation
   - Service implementations for external integrations
   - DTOs for SwiftData persistence

3. **App Module**: UI and interaction
   - MVVM pattern with ViewModels
   - Navigation management (NavigationManager)
   - SwiftUI views organized by feature
   - App configuration and DI setup (MacmoApp, Dependencies)
   - Unit tests for all layers

#### Key Design Patterns
- **Micro-Projects Architecture**: Strong module isolation with Tuist
- **Repository + DAO**: Repository handles caching, DAO handles persistence
- **Use Case Pattern**: Orchestrates multiple services (Repository + CalendarService)
- **Clean Architecture Boundaries**: UseCase → Repository → DAO (proper layer separation)
- **Protocol-Oriented**: Every implementation has a domain protocol
- **Dependency Injection**: Factory framework with automatic mock switching for previews

### Target Platform
- **macOS 15.0+**: Minimum deployment target for macOS
- **iOS 18.0+**: Minimum deployment target for iOS
- **Multi-platform**: Supports macOS, iOS, and iPad
- **Bundle ID**: `dev.tuist.macmo`
- **Architecture**: Native SwiftUI application with multi-window support

## Migration Notes

This project was migrated from a single-target structure to micro-projects architecture:

### Migration Steps Completed:
1. **Old structure**: Single `Project.swift` with all code in `macmo/Sources/`
2. **New structure**: Three independent projects (MacmoDomain, MacmoData, App)
3. **Backup**: Old `Project.swift` saved as `Project.swift.backup`
4. **Import changes**: All `import Domain` → `import MacmoDomain`, `import Data` → `import MacmoData`
5. **File reorganization**:
   - `macmo/Sources/domain/` → `Projects/Domain/Sources/`
   - `macmo/Sources/data/` → `Projects/Data/Sources/`
   - `macmo/Sources/app/` → `Projects/App/Sources/`
   - `macmo/Resources/` → `Projects/App/Resources/`
   - `macmo/Tests/` → `Projects/App/Tests/`
   - `macmo/Widget/` → `Projects/App/Widget/`
   - `macmo/macmo.entitlements` → `Projects/App/macmo.entitlements`
6. **Legacy cleanup**: Original `macmo/` directory removed after migration completion

### Verification:
- ✅ Build: `xcodebuild build` successful
- ✅ Tests: All 21 tests passing (`tuist test`)
- ✅ Project generation: `tuist generate` working correctly

This is a production-ready macOS/iOS memo application with modern Swift patterns, modular architecture, and comprehensive test coverage.
