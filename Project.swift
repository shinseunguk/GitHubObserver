import ProjectDescription

let project = Project(
    name: "GitHubObserver",
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "0.8.0")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .branch("master")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher",
            requirement: .branch("master")
        ),
        .remote(
            url: "https://github.com/no-comment/KeyboardToolbar.git",
            requirement: .branch("main")
        )
    ],
    targets: [
        .target(
            name: "GitHubObserver",
            destinations: .iOS,
            product: .app,
            bundleId: "com.ukseung.GitHubObserver",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
                "CFBundleURLTypes": [
                    [
                        "CFBundleURLName": "GitHubObserver",
                        "CFBundleURLSchemes": ["GitHubObserver"]
                    ]
                ]
            ]),
            sources: ["GitHubObserver/Sources/**"],
            resources: ["GitHubObserver/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                .package(product: "Moya"),
                .package(product: "Kingfisher"),
                .package(product: "KeyboardToolbar")
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: .debug),
                    .debug(name: "QA"),
                    .release(name: .release)
                ],
                defaultSettings: .recommended
            )
        ),
        .target(
            name: "GitHubObserverTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ukseung.GitHubObserverTests",
            infoPlist: .default,
            sources: ["GitHubObserver/Tests/**"],
            resources: [],
            dependencies: [.target(name: "GitHubObserver")]
        ),
    ]
)
