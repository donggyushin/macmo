import ProjectDescription

let project = Project(
    name: "macmo",
    packages: [
        .remote(url: "https://github.com/hmlongco/Factory", requirement: .upToNextMajor(from: "2.3.2")),
        .remote(url: "https://github.com/gonzalezreal/swift-markdown-ui", requirement: .upToNextMajor(from: "2.4.0")),
    ],
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "DEVELOPMENT_TEAM": "YV58Q28W8Z",
            "CODE_SIGN_STYLE": "Automatic",
            "MARKETING_VERSION": "1.8.0",
            "CURRENT_PROJECT_VERSION": "1",
            "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.productivity",
            "PRODUCT_NAME": "boot",
            "INFOPLIST_KEY_CFBundleDisplayName": "boot",
        ],
        configurations: [
            .debug(name: .debug, settings: [
                "PRODUCT_NAME": "boot-debug",
                "INFOPLIST_KEY_CFBundleDisplayName": "boot-debug",
            ]),
            .release(name: .release, settings: [
                "PRODUCT_NAME": "boot",
                "INFOPLIST_KEY_CFBundleDisplayName": "boot",
            ]),
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
                "CFBundleName": "$(PRODUCT_NAME)",
                "CFBundleDisplayName": "$(INFOPLIST_KEY_CFBundleDisplayName)",
                "NSCalendarsFullAccessUsageDescription": "macmo needs calendar access to save your memos with due dates to your calendar.",
                "UILaunchScreen": [:],
                "UIBackgroundModes": ["remote-notification"],
                "LSApplicationCategoryType": "public.app-category.productivity",
                "ITSAppUsesNonExemptEncryption": false,
            ]),
            buildableFolders: [
                "macmo/Sources",
                "macmo/Resources",
            ],
            entitlements: "macmo/macmo.entitlements",
            dependencies: [
                .package(product: "Factory"),
                .package(product: "MarkdownUI"),
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=macosx*]": "AppIcon",
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=iphoneos*]": "AppIconIOS",
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=iphonesimulator*]": "AppIconIOS",
            ])
        ),
        .target(
            name: "macmoTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.macmoTests",
            infoPlist: .default,
            buildableFolders: [
                "macmo/Tests",
            ],
            dependencies: [.target(name: "macmo")]
        ),
    ]
)
