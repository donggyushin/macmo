import ProjectDescription

let project = Project(
    name: "macmo",
    targets: [
        .target(
            name: "macmo",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.macmo",
            infoPlist: .default,
            buildableFolders: [
                "macmo/Sources",
                "macmo/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "macmoTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.macmoTests",
            infoPlist: .default,
            buildableFolders: [
                "macmo/Tests"
            ],
            dependencies: [.target(name: "macmo")]
        ),
    ]
)
