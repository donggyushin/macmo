# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **macOS SwiftUI memo application** built with Tuist and SwiftData, following Domain-Driven Design principles.

## Essential Development Commands

### Project Generation and Building
```bash
# Generate Xcode project from Tuist configuration
tuist generate

# Generate and immediately open in Xcode
tuist generate --open

# Build the project via Tuist
tuist build

# Clean build artifacts
tuist clean

# Edit project configuration in temporary project
tuist edit
```

### Testing
```bash
# Run tests through Xcode (after generating project)
xcodebuild test -workspace macmo.xcworkspace -scheme macmo -destination 'platform=macOS'

# Or run tests in Xcode IDE after opening generated workspace
```

### Dependency Management
```bash
# Install/update dependencies (handled automatically by Tuist)
tuist generate  # Re-generates with latest dependency versions

# Check dependency resolution
cat .package.resolved
```

## High-Level Architecture

### Project Structure Overview
This is a **Tuist-managed macOS SwiftUI application** following **Domain-Driven Design (DDD)** and **Clean Architecture** patterns with clear separation of concerns across three main layers:

```
macmo/Sources/
├── domain/          # Core business logic (entities, protocols, interfaces)
│   ├── entity/      # Domain entities (Memo, MemoSort)
│   ├── repository/  # Repository protocol interfaces
│   ├── service/     # Service protocol interfaces (CalendarService)
│   └── usecase/     # Application use cases (business logic orchestration)
├── data/            # Infrastructure & data layer
│   ├── dao/         # Data Access Object (DAO) implementations & protocols
│   ├── dto/         # Data Transfer Objects for persistence (SwiftData models)
│   ├── repository/  # Repository implementations
│   ├── schema/      # SwiftData schema versions & migrations
│   └── service/     # Service implementations (CalendarService, etc.)
└── presentation/    # UI layer (SwiftUI views & ViewModels)
    ├── list/        # Memo list views
    ├── detail/      # Memo detail views
    ├── search/      # Search views
    ├── components/  # Reusable UI components
    └── store/       # State management (MemoStore)
```

### Key Architectural Patterns

#### 1. Domain-Driven Design Layer Separation
- **Domain Layer** (`/domain/`): Contains pure business logic with no external dependencies
  - **Entities** (`/entity/`): Core domain models
    - `Memo.swift`: Core domain entity with business rules
    - `MemoSort.swift`: Sorting strategy enumeration
  - **Repository Protocols** (`/repository/`): Data access interfaces
    - `MemoRepositoryProtocol.swift`: Repository interface defining CRUD + sorting operations
  - **Service Protocols** (`/service/`): External service interfaces
    - `CalendarServiceProtocol.swift`: Calendar integration interface
  - **Use Cases** (`/usecase/`): Business logic orchestration
    - `MemoUseCase.swift`: Coordinates memo operations with calendar sync

- **Data Layer** (`/data/`): Infrastructure implementations and data persistence
  - **DAO** (`/dao/`): Low-level data access
    - `MemoDAOProtocol.swift`: DAO interface for persistence operations
    - `MemoDAO.swift`: SwiftData-based DAO implementation
    - `MockMemoDAO.swift`: In-memory DAO for testing/development
  - **Repository** (`/repository/`): Repository pattern implementations
    - `MemoRepository.swift`: Implements MemoRepositoryProtocol, delegates to DAO + caching
  - **DTO** (`/dto/`): Data Transfer Objects
    - `MemoDTO.swift`: SwiftData model with domain mapping methods
  - **Schema** (`/schema/`): SwiftData schema management
    - `MemoSchemaV1.swift`, `MemoSchemaV2.swift`: Schema versions
    - `MemoMigrationPlan.swift`: Migration strategy
  - **Services** (`/service/`): External service implementations
    - `CalendarService.swift`: EventKit-based calendar integration
    - `MockCalendarService.swift`: Mock calendar service for testing

- **Presentation Layer** (`/presentation/`): SwiftUI views, ViewModels, and state management
  - `MemoStore.swift`: Centralized state management with selection tracking
  - `MemoDetailViewModel.swift`: Detail view business logic
  - `SearchMemoViewModel.swift`: Search functionality
  - Various SwiftUI views organized by feature

#### 2. Repository Pattern with DAO Abstraction
The codebase implements a **multi-layered Repository pattern**:

**Three-Layer Data Access Architecture:**
1. **Repository Layer** (Domain interface → Data implementation)
   - **Protocol**: `MemoRepositoryProtocol` (in `/domain/repository/`)
   - **Implementation**: `MemoRepository` (in `/data/repository/`)
   - **Responsibilities**: User preferences caching (sort order, ascending), delegates persistence to DAO

2. **DAO Layer** (Low-level persistence abstraction)
   - **Protocol**: `MemoDAOProtocol` (in `/data/dao/`)
   - **Production**: `MemoDAO` - SwiftData persistence
   - **Mock**: `MockMemoDAO` - In-memory storage with sample data
   - **Responsibilities**: Direct database operations (CRUD, search, pagination)

3. **Use Case Layer** (Business logic orchestration)
   - **Implementation**: `MemoUseCase` (in `/domain/usecase/`)
   - **Responsibilities**: Coordinates memo operations with calendar service integration
   - **Pattern**: Uses both DAO (for persistence) and CalendarService (for calendar sync)

**Key Design Decisions:**
- **Repository wraps DAO**: Repository adds caching layer (UserDefaults for sort preferences) on top of DAO
- **UseCase orchestrates**: Combines multiple services (DAO + CalendarService) for complex operations
- **Domain-DTO Mapping**: Explicit `toDomain()` and `fromDomain()` methods
- **Protocol-first**: Every implementation has a corresponding protocol in the domain layer

#### 3. Dependency Injection with Factory
- **Factory Framework**: Fully integrated Factory DI framework (v2.5.3)
- **Configured in**: `presentation/Dependencies.swift`
- **Injection Hierarchy**:
  - `ModelContainer` → `ModelContext` (SwiftData setup)
  - `MemoDAO` (production: `MemoDAO`, preview: `MockMemoDAO`)
  - `MemoRepository` (wraps `MemoDAO`)
  - `CalendarService` (production: `CalendarService`, preview: `MockCalendarService`)
  - `MemoUseCase` (combines `MemoDAO` + `CalendarService`)
- **Usage Pattern**: `@Injected(\.memoRepository)` in ViewModels and stores

### Key Dependencies

#### Core Frameworks
- **SwiftUI**: UI framework for macOS application
- **SwiftData**: Apple's modern data persistence framework with schema migration
- **EventKit**: Calendar integration for due date reminders
- **Foundation**: Core Swift framework

#### External Dependencies
- **Factory** (v2.5.3): Dependency injection framework by @hmlongco
  - Fully integrated in `presentation/Dependencies.swift`
  - Used throughout the app for injecting repositories, DAOs, and services

#### Development Tools
- **Tuist** (v4.68.0): Project generation and build system management
- **mise**: Tool version management (specified in `mise.toml`)
- **Fastlane**: Automated build and release pipeline

## Important Conventions & Patterns

### File Organization Rules
1. **Domain purity**: Domain layer contains only protocols, entities, and use cases - no framework dependencies
2. **Data layer isolation**: All infrastructure concerns (persistence, external services) live in `/data/`
3. **DTO-Domain separation**: Clear mapping between SwiftData DTOs and domain models
4. **Protocol-first design**: All data access and services go through protocol interfaces defined in domain
5. **Sample data patterns**: Mock implementations include realistic sample data via static factory methods

### Layered Architecture Patterns
- **Domain Layer**: Pure business logic, no external dependencies
  - Protocols define contracts
  - Entities define business objects
  - Use cases orchestrate business operations
- **Data Layer**: Infrastructure implementations
  - DAOs handle low-level persistence
  - Repositories add caching/preferences on top of DAOs
  - Services implement external integrations (Calendar, etc.)
- **Presentation Layer**: UI and user interaction
  - Views (SwiftUI)
  - ViewModels (business logic for views)
  - Stores (centralized state management)

### Persistence Patterns
- **SwiftData Integration**: Uses `@Model` macro for DTOs with `@Attribute(.unique)` for IDs
- **Schema Migration**: Versioned schemas (`MemoSchemaV1`, `MemoSchemaV2`) with migration plan
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
- **Use Case Pattern**: `MemoUseCase` coordinates DAO + CalendarService operations
- **Error Handling**: Graceful degradation if calendar access denied

### Testing & Preview Patterns
- **Mock Implementations**: Dedicated mock classes for DAOs and services
- **Factory Preview Switching**: `.onPreview { MockImplementation }` for SwiftUI previews
- **Static Factories**: `MockMemoDAO.withSampleData()` for consistent test data
- **Protocol Testing**: Tests target protocol interfaces rather than concrete implementations

### Development Workflow
1. Always run `tuist generate` after making configuration changes
2. Use mock implementations for SwiftUI previews (automatically via Factory)
3. Domain layer should remain framework-agnostic (protocols and entities only)
4. Infrastructure implementations go in `/data/` layer
5. Use cases coordinate between multiple services
6. Repositories add caching/preferences on top of DAOs

## Current Implementation Status

### ✅ Fully Implemented
- **Domain Layer**:
  - Complete domain entities (`Memo`, `MemoSort`, `CalendarServiceError`)
  - Repository protocol (`MemoRepositoryProtocol`)
  - Service protocols (`CalendarServiceProtocol`)
  - Use cases (`MemoUseCase` with calendar integration)

- **Data Layer**:
  - DAO layer with protocol and implementations (`MemoDAO`, `MockMemoDAO`)
  - Repository implementation (`MemoRepository` with UserDefaults caching)
  - SwiftData persistence with DTO mapping (`MemoDTO`)
  - Schema migration (`MemoSchemaV1`, `MemoSchemaV2`, `MemoMigrationPlan`)
  - Calendar service integration (`CalendarService`, `MockCalendarService`)

- **Presentation Layer**:
  - Complete MVVM pattern with ViewModels
  - Centralized state management (`MemoStore`)
  - Full UI implementation:
    - Split view navigation with list and detail
    - Search functionality with special filters
    - Multi-window support for new memos
    - Context menu operations
    - Due date management with overdue indicators
    - Task completion tracking

- **Infrastructure**:
  - Factory dependency injection fully configured
  - SwiftData + CloudKit integration
  - EventKit calendar integration
  - Cursor-based pagination
  - Three-way sorting (created/updated/due)
  - Real-time UI updates

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

#### Three-Layer Clean Architecture
1. **Domain Layer** (`/domain/`): Business logic core
   - Protocols for all external contracts
   - Pure entities with no framework dependencies
   - Use cases for orchestrating business operations

2. **Data Layer** (`/data/`): Infrastructure implementations
   - DAO pattern for persistence abstraction
   - Repository pattern for caching + DAO delegation
   - Service implementations for external integrations

3. **Presentation Layer** (`/presentation/`): UI and interaction
   - MVVM pattern with ViewModels
   - Centralized state management (MemoStore)
   - SwiftUI views organized by feature

#### Key Design Patterns
- **Repository + DAO**: Repository handles caching, DAO handles persistence
- **Use Case Pattern**: Orchestrates multiple services (DAO + CalendarService)
- **Protocol-Oriented**: Every implementation has a domain protocol
- **Dependency Injection**: Factory framework with automatic mock switching for previews

### Target Platform
- **macOS 15.0+**: Minimum deployment target
- **Bundle ID**: `dev.tuist.macmo`
- **Architecture**: Native macOS SwiftUI application with multi-window support

This is a production-ready macOS memo application with modern Swift patterns and native macOS user experience.