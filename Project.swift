import ProjectDescription

let project = Project(
    name: "macmo",
    packages: [
        .remote(url: "https://github.com/hmlongco/Factory", requirement: .upToNextMajor(from: "2.3.2"))
    ],
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "DEVELOPMENT_TEAM": "YV58Q28W8Z",
            "CODE_SIGN_STYLE": "Automatic"
        ]
    ),
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
            entitlements: "macmo/macmo.entitlements",
            dependencies: [
                .package(product: "Factory")
            ]
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
