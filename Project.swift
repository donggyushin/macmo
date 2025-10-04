import ProjectDescription

let project = Project(
    name: "macmo",
    packages: [
        .remote(url: "https://github.com/hmlongco/Factory", requirement: .upToNextMajor(from: "2.3.2")),
        .remote(url: "https://github.com/gonzalezreal/swift-markdown-ui", requirement: .upToNextMajor(from: "2.4.0"))
    ],
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "DEVELOPMENT_TEAM": "YV58Q28W8Z",
            "CODE_SIGN_STYLE": "Automatic",
            "MARKETING_VERSION": "1.7.1",
            "CURRENT_PROJECT_VERSION": "1",
            "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.productivity"
        ],
        configurations: [
            .debug(name: .debug, settings: [
                "PRODUCT_NAME": "macmo-debug",
                "INFOPLIST_KEY_CFBundleDisplayName": "macmo-debug"
            ]),
            .release(name: .release, settings: [
                "PRODUCT_NAME": "macmo",
                "INFOPLIST_KEY_CFBundleDisplayName": "macmo"
            ])
        ]
    ),
    targets: [
        .target(
            name: "macmo",
            destinations: [.mac, .iPhone, .iPad],
            product: .app,
            bundleId: "dev.tuist.macmo",
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                "NSCalendarsFullAccessUsageDescription": "macmo needs calendar access to save your memos with due dates to your calendar.",
                "UILaunchScreen": [:],
                "UIBackgroundModes": ["remote-notification"],
                "LSApplicationCategoryType": "public.app-category.productivity"
            ]),
            buildableFolders: [
                "macmo/Sources",
                "macmo/Resources",
            ],
            entitlements: "macmo/macmo.entitlements",
            dependencies: [
                .package(product: "Factory"),
                .package(product: "MarkdownUI")
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
