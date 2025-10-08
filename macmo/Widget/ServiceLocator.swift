
import Foundation
import SwiftData

private var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
private var isTest: Bool = {
    var testing = false
    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
        testing = true
    }
    if ProcessInfo.processInfo.processName.contains("xctest") {
        testing = true
    }
    return testing
}()

final class ServiceLocator {
    static let shared = ServiceLocator()
    private init() {}

    lazy var modelContainer: ModelContainer = {
        do {
            let configuration: ModelConfiguration

            if let appGroupURL = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.dev.tuist.macmo")?
                .appendingPathComponent("default.store")
            {
                configuration = ModelConfiguration(
                    url: appGroupURL,
                    cloudKitDatabase: .automatic
                )
            } else {
                configuration = ModelConfiguration(
                    cloudKitDatabase: .automatic
                )
            }

            let container = try ModelContainer(
                for: MemoDTO.self,
                configurations: configuration
            )

            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }

    }()

    var modelContext: ModelContext {
        let container = modelContainer
        return ModelContext(container)
    }

    lazy var memoRepository: MemoRepository = {
        if isPreview || isTest {
            return MemoRepositoryMock()
        }

        return MemoRepositoryImpl(modelContext: modelContext)
    }()
}
