// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PalmierSkillBundle",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "PalmierSkillBundle", targets: ["PalmierSkillBundle"]),
    ],
    targets: [
        .target(
            name: "PalmierSkillBundle",
            resources: [
                .copy("Resources/Skills"),
            ]
        )
    ]
)
