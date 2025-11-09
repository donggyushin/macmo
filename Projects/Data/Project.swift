import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MacmoData",
    settings: commonSettings,
    targets: [
        .makeFramework(
            name: "MacmoData",
            destinations: [.mac, .iPhone, .iPad],
            dependencies: [
                .project(target: "MacmoDomain", path: .relativeToRoot("Projects/Domain"))
            ]
        )
    ]
)
