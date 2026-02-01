import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "App",
    packages: [
        .factory,
        .markdownUI
    ],
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "DEVELOPMENT_TEAM": "YV58Q28W8Z",
            "CODE_SIGN_STYLE": "Automatic",
            "MARKETING_VERSION": "1.17.0",
            "CURRENT_PROJECT_VERSION": "25",
            "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.productivity",
            "PRODUCT_NAME": "dgmemo",
            "INFOPLIST_KEY_CFBundleDisplayName": "dgmemo"
        ],
        configurations: [
            .debug(
                name: .debug,
                settings: [
                    "PRODUCT_BUNDLE_IDENTIFIER": "dev.tuist.macmo.debug",
                    "PRODUCT_NAME": "dgmemo-debug",
                    "INFOPLIST_KEY_CFBundleDisplayName": "dgmemo-debug"
                ]
            ),
            .release(
                name: .release,
                settings: [
                    "PRODUCT_BUNDLE_IDENTIFIER": "dev.tuist.macmo",
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
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
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
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "macmo.entitlements",
            dependencies: [
                .project(target: "MacmoDomain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "MacmoData", path: .relativeToRoot("Projects/Data")),
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
            name: "macmoWidgetExtension",
            destinations: [.iPhone, .iPad, .mac],
            product: .appExtension,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER).widget",
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "dgmemo Widget",
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ]
            ]),
            sources: ["Widget/**"],
            entitlements: "macmo.entitlements",
            dependencies: [
                .project(target: "MacmoDomain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "MacmoData", path: .relativeToRoot("Projects/Data"))
            ]
        ),
        .target(
            name: "macmoTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.macmoTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "macmo"),
                .project(target: "MacmoDomain", path: .relativeToRoot("Projects/Domain")),
                .project(target: "MacmoData", path: .relativeToRoot("Projects/Data"))
            ]
        )
    ]
)
