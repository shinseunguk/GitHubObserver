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
        )
    ],
    settings: .settings(
        base: ["DEVELOPMENT_TEAM": "승욱 신 (Personal Team)"],
        configurations: [
            .debug(name: .debug),
            .debug(name: "QA"),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "GitHubObserver",
            destinations: .iOS,
            product: .app,
            bundleId: "com.ukseung.GitHubObserver",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["GitHubObserver/Sources/**"],
            resources: ["GitHubObserver/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture")
            ]
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
