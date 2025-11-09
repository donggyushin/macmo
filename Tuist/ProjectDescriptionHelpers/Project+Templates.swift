import ProjectDescription

// MARK: - Common Settings
public let commonSettings: Settings = .settings(
    base: [
        "MACOSX_DEPLOYMENT_TARGET": "15.0",
        "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
        "DEVELOPMENT_TEAM": "YV58Q28W8Z",
        "CODE_SIGN_STYLE": "Automatic",
        "SWIFT_VERSION": "6.0"
    ],
    configurations: [
        .debug(name: .debug),
        .release(name: .release)
    ]
)

// MARK: - Framework Target Factory
extension Target {
    public static func makeFramework(
        name: String,
        destinations: Destinations = [.mac, .iPhone, .iPad],
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: destinations,
            product: .framework,
            bundleId: "dev.tuist.macmo.\(name)",
            deploymentTargets: .multiplatform(
                iOS: "18.0",
                macOS: "15.0"
            ),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: dependencies
        )
    }
}

// MARK: - External Packages
extension Package {
    public static let factory = Package.remote(
        url: "https://github.com/hmlongco/Factory",
        requirement: .upToNextMajor(from: "2.3.2")
    )

    public static let markdownUI = Package.remote(
        url: "https://github.com/gonzalezreal/swift-markdown-ui",
        requirement: .upToNextMajor(from: "2.4.0")
    )
}
