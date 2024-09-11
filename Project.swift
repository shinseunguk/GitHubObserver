import ProjectDescription

let project = Project(
    name: "GitHubObserver",
    targets: [
        .target(
            name: "GitHubObserver",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.GitHubObserver",
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
            dependencies: []
        ),
        .target(
            name: "GitHubObserverTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.GitHubObserverTests",
            infoPlist: .default,
            sources: ["GitHubObserver/Tests/**"],
            resources: [],
            dependencies: [.target(name: "GitHubObserver")]
        ),
    ]
)
