# Claude Development Context

This file contains essential information for Claude to understand the macmo project structure, development patterns, and workflow.

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
├── domain/          # Core business logic (entities, protocols)
│   ├── model/       # Domain entities (pure business objects)
│   └── dao/         # Data access protocols/interfaces
├── service/         # Infrastructure & application services
│   ├── dao/         # Concrete DAO implementations
│   └── dto/         # Data Transfer Objects for persistence
└── presentation/    # UI layer (SwiftUI views)
```

### Key Architectural Patterns

#### 1. Domain-Driven Design Layer Separation
- **Domain Layer** (`/domain/`): Contains pure business logic with no external dependencies
  - `Memo.swift`: Core domain entity with business rules
  - `MemoDAOProtocol.swift`: Repository pattern interface
- **Service Layer** (`/service/`): Infrastructure implementations and application services
  - `MemoDAO.swift`: SwiftData-based persistence implementation
  - `MockMemoDAO.swift`: In-memory implementation for testing/development
  - `MemoDTO.swift`: SwiftData model with domain mapping
- **Presentation Layer** (`/presentation/`): SwiftUI views and UI logic

#### 2. Repository Pattern Implementation
The codebase implements a clean Repository pattern:
- **Protocol**: `MemoDAOProtocol` defines the contract (CRUD operations)
- **Production Implementation**: `MemoDAO` uses SwiftData for persistence
- **Test Implementation**: `MockMemoDAO` provides in-memory storage with sample data
- **Domain-DTO Mapping**: Explicit conversion between domain models and persistence DTOs

#### 3. Dependency Injection Ready
- **Factory Framework**: Project includes Factory dependency injection framework (v2.5.3)
- **Protocol-Based Design**: DAO implementations are easily swappable via protocols
- **Note**: Factory is configured but not yet actively used in the current codebase

### Key Dependencies

#### Core Frameworks
- **SwiftUI**: UI framework for macOS application
- **SwiftData**: Apple's modern data persistence framework
- **Foundation**: Core Swift framework

#### External Dependencies
- **Factory** (v2.5.3): Dependency injection framework by @hmlongco
  - Configured in `Project.swift` but not yet implemented in code
  - Ideal for injecting DAO implementations into ViewModels/Services

#### Development Tools
- **Tuist** (v4.68.0): Project generation and build system management
- **mise**: Tool version management (specified in `mise.toml`)

## Important Conventions & Patterns

### File Organization Rules
1. **Domain purity**: Domain layer files have no framework imports except Foundation
2. **DTO-Domain separation**: Clear mapping between SwiftData DTOs and domain models
3. **Protocol-first design**: All data access goes through protocol interfaces
4. **Sample data patterns**: Mock implementations include realistic sample data via static factory methods

### Persistence Patterns
- **SwiftData Integration**: Uses `@Model` macro for DTOs with `@Attribute(.unique)` for IDs
- **Domain Mapping**: Explicit `toDomain()` and `fromDomain()` methods for DTO-Domain conversion
- **Error Handling**: All DAO methods throw for proper error propagation
- **Sorting**: Default sort by `createdAt` in reverse order (newest first)

### Testing Patterns
- **Mock Implementations**: Dedicated mock classes with sample data
- **Static Factories**: `MockMemoDAO.withSampleData()` for consistent test data
- **Protocol Testing**: Tests can target the protocol interface rather than specific implementations

### Development Workflow
1. Always run `tuist generate` after making configuration changes
2. Use mock implementations during UI development before persistence is ready
3. Domain models should remain framework-agnostic
4. DTOs handle SwiftData-specific requirements and mapping

## Current Implementation Status

### Implemented
- ✅ Complete domain model (`Memo`)
- ✅ Repository pattern with protocol and implementations
- ✅ SwiftData persistence layer with DTO mapping
- ✅ Mock implementation with sample data
- ✅ Basic SwiftUI application structure
- ✅ Tuist project configuration

### Ready for Development
- 🔄 Factory dependency injection integration
- 🔄 SwiftUI ViewModels and business logic
- 🔄 Complete UI implementation (currently shows "Hello, World!")
- 🔄 Real test coverage (currently has placeholder test)

### Target Platform
- **macOS 15.0+**: Minimum deployment target specified in Tuist configuration
- **Bundle ID**: `dev.tuist.macmo`

This architecture provides a solid foundation for a maintainable, testable memo application with clear separation of concerns and modern Swift development practices.