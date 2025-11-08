import ProjectDescription

let project = Project(
    name: "macmo",
    packages: [
        .remote(
            url: "https://github.com/hmlongco/Factory", requirement: .upToNextMajor(from: "2.3.2")
        ),
        .remote(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            requirement: .upToNextMajor(from: "2.4.0")
        )
    ],
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "DEVELOPMENT_TEAM": "YV58Q28W8Z",
            "CODE_SIGN_STYLE": "Automatic",
            "MARKETING_VERSION": "1.9.1",
            "CURRENT_PROJECT_VERSION": "11",
            "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.productivity",
            "PRODUCT_NAME": "dgmemo",
            "INFOPLIST_KEY_CFBundleDisplayName": "dgmemo"
        ],
        configurations: [
            .debug(
                name: .debug,
                settings: [
                    "PRODUCT_NAME": "dgmemo-debug",
                    "INFOPLIST_KEY_CFBundleDisplayName": "dgmemo-debug"
                ]
            ),
            .release(
                name: .release,
                settings: [
                    "PRODUCT_NAME": "dgmemo",
                    "INFOPLIST_KEY_CFBundleDisplayName": "dgmemo"
                ]
            )
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
                "NSCalendarsFullAccessUsageDescription":
                    "macmo needs calendar access to save your memos with due dates to your calendar.",
                "UILaunchScreen": [:],
                "UIBackgroundModes": ["remote-notification"],
                "LSApplicationCategoryType": "public.app-category.productivity",
                "ITSAppUsesNonExemptEncryption": false,
                "CFBundleURLTypes": [
                    [
                        "CFBundleURLSchemes": ["macmo"],
                        "CFBundleURLName": "dev.tuist.macmo"
                    ]
                ]
            ]),
            buildableFolders: [
                "macmo/Sources",
                "macmo/Resources"
            ],
            entitlements: "macmo/macmo.entitlements",
            dependencies: [
                .package(product: "Factory"),
                .package(product: "MarkdownUI"),
                .target(name: "macmoWidgetExtension")
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=macosx*]": "AppIcon",
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=iphoneos*]": "AppIconIOS",
                "ASSETCATALOG_COMPILER_APPICON_NAME[sdk=iphonesimulator*]": "AppIconIOS"
            ])
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
        .target(
            name: "macmoWidgetExtension",
            destinations: [.iPhone, .iPad, .mac],
            product: .appExtension,
            bundleId: "dev.tuist.macmo.widget",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "dgmemo Widget",
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ]
            ]),
            buildableFolders: [
                "macmo/Widget"
            ],
            entitlements: "macmo/macmo.entitlements",
            dependencies: []
        )
    ]
)
