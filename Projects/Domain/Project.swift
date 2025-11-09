import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MacmoDomain",
    settings: commonSettings,
    targets: [
        .makeFramework(
            name: "MacmoDomain",
            destinations: [.mac, .iPhone, .iPad],
            dependencies: []
        )
    ]
)
