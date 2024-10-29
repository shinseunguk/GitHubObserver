# 🐈 Github REST API를 활용한 Repository 검색 앱
## 프로젝트 소개

- Github Rest API를 활용한 앱
- 다른 사람의 Repository를 검색할 수 있는 기능
- 로그인을 하면, 자신의 Profile 및 Repository를 불러올 수 있는 기능


<br>

## 팀원 구성

<div align="center">

| **신승욱** |
| :------: |
| [<img src="https://avatars.githubusercontent.com/u/69791286?v=4" height=150 width=150> <br/> @shinseunguk](https://github.com/shinseunguk) |

</div>

<br>

## 1. 개발 환경

- Front : iOS(SwiftUI + TCA)
- Back-end : Github Rest API
- 버전 및 이슈관리 : Github, Github Issues, Github Project
- 협업 툴 : N/A
- Library : TCA, Moya, Kingfisher, KeyboardToolbar, Tuist
- 서비스 배포 환경 : 로컬 구동 및 TestFlight
<br>

## 2. 채택한 개발 기술과 Trouble Shooting

## 개발 기술

#### SwiftUI
- SwiftUI를 이용하여 프로젝트의 기본적인 UI와 화면 구성을 구현하였습니다. SwiftUI의 선언형 문법을 활용해 보다 직관적이고 코드가 간결한 사용자 인터페이스를 구축할 수 있었습니다. 또한, SwiftUI의 다양한 View와 컴포넌트를 활용하여 동적인 인터페이스와 사용자 친화적인 UX를 만들고자 했습니다.

#### TCA (The Composable Architecture)
- Composable Architecture(TCA)를 채택하여 애플리케이션의 상태 관리와 로직을 구조화하였습니다. TCA는 SwiftUI와 궁합이 좋아 프로젝트의 모듈성과 테스트 가능성을 높이는 데 큰 도움을 주었습니다. 특히 복잡한 상태 관리와 비동기 작업을 효과적으로 처리할 수 있어 코드의 유지보수성과 확장성이 개선되었습니다.

#### Tuist
- 프로젝트를 보다 쉽게 구성하고 관리하기 위해 Tuist를 도입했습니다. Tuist를 통해 프로젝트 구성을 자동화하고 의존성 관리를 효율적으로 처리할 수 있었으며, 여러 모듈로 분리된 구조에서도 일관성을 유지할 수 있었습니다. 이를 통해 빌드 시간이 단축되고 팀 작업의 생산성을 높일 수 있었습니다.

### GitFlow
- **GitFlow**를 채택하여 프로젝트의 버전 관리를 체계적으로 진행했습니다. GitFlow는 주요 브랜치를 역할에 따라 분리함으로써 안정성과 협업 효율을 높일 수 있는 브랜치 전략입니다. 
- **master** 브랜치는 안정적인 릴리스 버전만을 포함하도록 유지하고, **develop** 브랜치를 통해 새로운 기능을 개발하며, **feature** 브랜치를 각 기능별로 생성하여 기능 단위로 작업을 분리하였습니다. 
- 릴리스가 준비되면 **release** 브랜치를 통해 안정화 작업을 진행하였고, 버그 수정이나 긴급한 업데이트는 **hotfix** 브랜치를 통해 master 브랜치에 직접 반영하였습니다. 이를 통해 협업 과정에서 충돌을 최소화하고, 체계적인 개발과 배포 프로세스를 유지할 수 있었습니다.


## Trouble Shooting

#### 1. 키보드에 View가 가려짐
- 키보드에 View가 가려지기 때문에 검색이 완료되거나 해당 버튼을 누를때 키보드가 내려가 UX를 향상 시켰습니다. 
<img width="300" alt="image" src="https://github.com/user-attachments/assets/014b011d-c492-4482-83f2-1e6631240c3a">

#### 2. Git Push할 때 Git API Token이 포함되어 있으면 Push 할 수 없음
- 블로그 참조(https://ukseung2.tistory.com/entry/error-GH013-Repository-rule-violations-found-for-HEAD)

#### 3. List가 아닌 LazyVStack 사용
- Image를 늦게 불러와 UX가 매끄럽지 못한 이슈가 있어 LazyVStack으로 변경 하였습니다.

```swift
ScrollView {
    LazyVStack(spacing: 10) {
        ForEach(Array(items.enumerated()), id: \.element.id) { listIndex, repository in
            RepositoryListView(
                avatarURL: repository.owner.avatarURL ?? "",
                repositoryName: repository.name ?? "",
                repostioryDescription: repository.description ?? "",
                language: repository.language ?? "",
                stargazersCount: repository.stargazersCount ?? 0
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .onTapGesture {
                // 아이템 클릭 이벤트 발생
                viewStore.send(.itemTapped(item: repository))
            }
            .buttonStyle(PlainButtonStyle()) // 버튼 스타일 설정
            
            Divider()
                .padding(.leading, 20)
                .frame(maxWidth: .infinity)
        }
    }
}
```



<br>

## 3. 프로젝트 구조

```
.
├── Derived
│   ├── InfoPlists
│   │   ├── GitHubInfo.plist
│   │   ├── GitHubObserver-Info.plist
│   │   └── GitHubObserverTests-Info.plist
│   └── Sources
│       ├── TuistAssets+GitHubObserver.swift
│       ├── TuistBundle+GitHubObserver.swift
│       └── TuistStrings+GitHubObserver.swift
├── GitHubObserver
│   ├── Resources
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── Preview Content
│   │   │   └── Preview Assets.xcassets
│   │   │       └── Contents.json
│   │   ├── en.lproj
│   │   │   └── Localizable.strings
│   │   └── ko.lproj
│   │       └── Localizable.strings
│   ├── Sources
│   │   ├── API
│   │   │   ├── APIConfig.json
│   │   │   ├── Error
│   │   │   │   └── GitHubError.swift
│   │   │   ├── Router
│   │   │   │   └── GitHubAPI.swift
│   │   │   └── Service
│   │   │       └── GitHubService.swift
│   │   ├── App
│   │   │   └── GitHubObserverApp.swift
│   │   ├── Extension
│   │   │   ├── Extension+Bundle.swift
│   │   │   ├── Extension+Color.swift
│   │   │   ├── Extension+String.swift
│   │   │   └── Extension+UIApplication.swift
│   │   ├── Model
│   │   │   ├── GithubHeader.swift
│   │   │   └── SearchRepository.swift
│   │   ├── Presentation
│   │   │   ├── CommonUI
│   │   │   │   ├── RepositoryListView.swift
│   │   │   │   └── SearchBar.swift
│   │   │   ├── Main
│   │   │   │   └── MainView.swift
│   │   │   ├── Profile
│   │   │   │   ├── ProfileFeature.swift
│   │   │   │   └── ProfileView.swift
│   │   │   ├── RepositorySearchDetail
│   │   │   │   └── RepositorySearchDetailView.swift
│   │   │   └── RepostiorySearch
│   │   │       ├── RepositorySearchFeature.swift
│   │   │       └── RepositorySearchView.swift
│   │   ├── Service
│   │   └── Utility
│   │       ├── DataBase
│   │       │   └── UserDefaults
│   │       │       └── AppUserDefaults.swift
│   │       └── Extract
│   │           └── ExtractString.swift
│   ├── Tests
│   │   └── GitHubObserverTests.swift
│   └── en.lproj
│       └── Localizable.strings
├── GitHubObserver.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   └── contents.xcworkspacedata
│   ├── xcshareddata
│   │   └── xcschemes
│   │       └── GitHubObserver.xcscheme
│   └── xcuserdata
│       └── incross0915.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── GitHubObserver.xcworkspace
│   ├── contents.xcworkspacedata
│   ├── xcshareddata
│   │   ├── IDEWorkspaceChecks.plist
│   │   ├── WorkspaceSettings.xcsettings
│   │   ├── swiftpm
│   │   │   ├── Package.resolved
│   │   │   └── configuration
│   │   └── xcschemes
│   │       └── GitHubObserver-Workspace.xcscheme
│   └── xcuserdata
│       └── incross0915.xcuserdatad
│           ├── UserInterfaceState.xcuserstate
│           ├── xcdebugger
│           │   └── Breakpoints_v2.xcbkptlist
│           └── xcschemes
│               └── xcschememanagement.plist
├── Project.swift
└── Tuist
    ├── Config.swift
    └── Package.swift
```

<br>

## 4. 역할 분담

### 🧑🏻‍💻신승욱

1. **Login / Logout**
   - [로그인] 버튼을 누를 경우 Github가 제공하는 OAuth 페이지로 이동하고 홈페이지에서 로그인이 완료가 되면 앱에 code값을 callback하게 됨 그 이후에 해당 code값으로 Rest API 요청을 진행

     <br>
   <div align="center">
      <img width="300" alt="image" src="https://github.com/user-attachments/assets/abb5e136-6a7a-47f1-9791-5547608f2bb3">
   </div>

     
2. **My Profile**
   - 로그인이 완료될 경우 API Response에서 필요한 데이터를 parsing하여 View에 Set

3. **My Repository**
   - 로그인이 완료될 경우 My Profile의 reponse값을 My Repostiory request payload에 담아 서버 요청

   <br>
   <div align="center">
      <img width="300" alt="image" src="https://github.com/user-attachments/assets/bbb84dd7-0f45-4809-80ec-a799b58b65cd">
   </div>


4. **Repository Search**
   - 로그인 유무와 관계 없이 Repository를 검색할 수 있음
   


## 5. 개발 기간 및 작업 관리

### 개발 기간

- 전체 개발 기간 : 2024-09-11 ~ 2024-10-25
- 기능 구현 : 2024-09-27 ~ 2024-10-25

<br>

## 6. 신경 쓴 부분

1. 데이터 은닉
   - 민감한 정보들은 plist에 넣고 `.gitignore`에 추가하여 해당 파일이 commit, push 되지 않도록 관리했습니다. 이를 통해 보안성을 강화하고, API 키 등의 민감한 정보를 안전하게 보호할 수 있도록 했습니다.

```swift
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>GITHUB_API_KEY</key>
	<string>{GITHUB_API_KEY}</string>
	<key>CLIENT_ID</key>
	<string>{CLIENT_ID}</string>
	<key>CLIENT_SERCRET</key>
	<string>{CLIENT_SERCRET}</string>
</dict>
</plist>
```
<br><br>

2. 네트워크 요청 최적화, Moya를 활용한 모듈화
   - 중복된 네트워크 요청을 방지하기 위해 요청을 효율적으로 관리하고, 상태를 통한 캐싱을 도입하여 불필요한 데이터 호출을 최소화했습니다. 이를 통해 성능과 네트워크 비용을 절감하고, 사용자 경험을 개선했습니다.
   - 네트워크 계층을 Moya를 통해 모듈화하여, API 요청을 간결하게 작성할 수 있도록 했습니다. 이를 통해 코드 가독성을 높이고, 네트워크 계층을 독립적으로 유지 및 관리할 수 있도록 구조화했습니다.

```swift
import Moya
import Foundation

// Define the GitHub API target
enum GitHubAPI {
    case searchRepositories(query: String, page: Int)
    case accessToken(code: String)
    case myInfo(token: String)
    case myRepos(ownerId: String)
}

extension GitHubAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .accessToken:
            return URL(string: "https://github.com/")!
        default:
            return URL(string: "https://api.github.com/")!
        }
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "search/repositories"
        case .accessToken:
            return "login/oauth/access_token"
        case .myInfo:
            return "user"
        case .myRepos(let ownerId):
            return "users/\(ownerId)/repos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchRepositories:
            return .get
        case .accessToken:
            return .post
        case .myInfo:
            return .get
        case .myRepos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .searchRepositories(query, page):
            return .requestParameters(
                parameters: [
                    "q": query,
                    "page": page
                ],
                encoding: URLEncoding.default
            )
        case let .accessToken(code):
            return .requestParameters(
                parameters: [
                    "client_id": Bundle.main.CLIENT_ID,
                    "client_secret": Bundle.main.CLIENT_SERCRET,
                    "code" : code
                ],
                encoding: URLEncoding.default
            )
        case .myInfo:
            return .requestParameters(
                parameters: [
                    "client_secret": Bundle.main.CLIENT_SERCRET
                ],
                encoding: URLEncoding.default
            )
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .myInfo(token):
            return [
                "Authorization": "token \(token)"
            ]
        default:
            return [:]
        }
    }
}
```
<br><br>

3. View
   - 재사용이 가능한 컴포넌트 형태로 개발하여, UI의 일관성을 유지하고 코드 중복을 줄였습니다. SwiftUI의 선언형 문법을 활용하여 가독성 높은 컴포넌트를 만들었으며, 각 컴포넌트는 역할에 따라 독립적으로 동작할 수 있도록 설계했습니다.
<br><br>

4. 다국어 처리
   - 앱 내의 텍스트와 메시지를 다국어로 지원하기 위해 `Localizable.strings` 파일을 사용해 다국어 처리를 구현했습니다. 이를 통해 글로벌 사용자를 고려한 인터페이스를 제공할 수 있도록 했습니다.
  <img width="1129" alt="image" src="https://github.com/user-attachments/assets/a1b3ec07-7a35-47cb-967f-4b3ebd1cbf4d">
  <br><br>

5. 상태 관리
   - TCA를 활용하여 앱의 상태를 효과적으로 관리하고, 모듈 간의 데이터 흐름을 명확하게 했습니다. 이를 통해 상태 변경을 체계적으로 추적하고 디버깅하기 쉽도록 했습니다.
     
  ```swift
import Foundation
import ComposableArchitecture
import UIKit

struct ProfileFeature: Reducer {
    
    private let githubService = GitHubService()
    private let userDefaults = AppUserDefaults.shared
    
    struct State: Equatable {
        var showingAlert: Bool = false
        var owner: Owner?
        var ownerId: String?
        var repostiory: [Item]?
        var isLoading: Bool = true
    }
    
    enum Action {
        case checkLogin
        case onAppear
        case setAlertDismissed
        case goToGitHubPage
        case setShowingAlert
        case logout
        case fetchError(error: GitHubError)
        case openURLReceived(URL)
        case requestMyInfo(token: String)
        case responseMyInfo(owner: Owner)
        case responseRepos(item: [Item])
        case itemTapped(item: Item)
    }
    
    enum ID: Hashable {
        case debounce, throttle
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .checkLogin:
            guard let owner = userDefaults.getOwner() else {
                return .none
            }
            state.owner = owner
            return .none
        case .onAppear:
            guard let token = userDefaults.getToken() else {
                state.owner = nil
                state.repostiory = nil
                state.showingAlert = true
                return .none
            }
            
            let requestMyInfo = githubService.requestMyInfo(token: token)
                .debounce(
                    id: ID.debounce,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.debounce)
            
            if let owner = userDefaults.getOwner() {
                state.owner = owner
            }
            
            return requestMyInfo
        case .setAlertDismissed:
            state.showingAlert = false
            return .none
        case .goToGitHubPage:
            print("goToGitHubPage")
            requestCode()
            return .none
        case .setShowingAlert:
            state.showingAlert = true
            return .none
        case .logout:
            userDefaults.removeOwner()
            userDefaults.removeToken()
            
            state.owner = nil
            state.ownerId = nil
            state.repostiory = nil
            
            print(".logout")
            return .none
        case .fetchError(let error):
            print("🚨 \(#file) \(#line) \(#function) \(error)")
            return .none
        case .openURLReceived(let url):
            guard let codeString = extractCode(from: url) else {
                return .none
            }
                return githubService.requestAccessToken(code: codeString)
                    .debounce(
                        id: ID.debounce,
                        for: 2.0,
                        scheduler: DispatchQueue.main
                    )
                    .cancellable(id: ID.debounce)
        case .requestMyInfo(let token):
            state.isLoading = true
            userDefaults.setToken(token)
            return githubService.requestMyInfo(token: token)
                .debounce(
                    id: ID.throttle,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.throttle)
        case .responseMyInfo(let owner):
            userDefaults.setOwner(owner)
            state.owner = owner
            state.ownerId = owner.login
            return githubService.requestMyRepository(ownerId: state.ownerId ?? "")
                .debounce(
                    id: ID.throttle,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.throttle)
        case .responseRepos(let item):
            state.isLoading = false
            state.repostiory = item
            return .none
        case .itemTapped(let item):
            if let url = item.htmlURL {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            }
            return .none
        }
    }
    
    func requestCode() {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Bundle.main.CLIENT_ID),
            URLQueryItem(name: "scope", value: "repo gist user"),
        ]
        
        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
        }
    }
}
```
<br><br>

6. 다크모드 대응
   - iOS의 다크모드와 라이트모드를 모두 지원하도록 디자인 색상을 설정하여, 다양한 환경에서 일관된 사용자 경험을 제공했습니다. 이를 통해 사용자가 선호하는 모드에서도 UI가 자연스럽게 동작할 수 있도록 했습니다.
<br><br>
7. 키보드가 내려가지 않는 현상 해결
   - SwiftUI의 기본 동작에서 발생할 수 있는 키보드 유지 문제를 해결하기 위해 서드파티인 `KeyboardToolbar` 라이브러리를 도입했습니다. 이를 통해 키보드가 상황에 맞게 자동으로 내려가도록 하여 UX를 개선했습니다.
<br><br>
8. 무한 스크롤 구현
   - 서버와 앱의 과부화를 막기 위한 무한 스크롤 구현
  


  




<br>

## 7. 개선 목표

- Github Rest API를 통해 만든 앱이기 때문에 Github가 제공하는 다양한 데이터와 API를 통해 기능을 늘려갈 것임.
    
<br>

## 8. 프로젝트 후기

### 🧑🏻‍💻 신승욱

- SwiftUI + TCA를 이용하여 처음 앱을 만들어 보았는데 SwiftUI는 안드로이드 xml, TCA는 ReactorKit과 유사한 구조를 가지고 있었기 때문에 기술을 습득하는데 그렇게 오래 걸리진 않았지만 개인적인 사정으로 프로젝트가 장시간 방치 되어 아쉬운 부분이 있었다. 또한, Rest API가 제공하는 데이터들은 많기 때문에 추가 개발 예정임.
- 추가적으로 Tuist는 이번에 처음 도입하여 써보게 됐는데 Tuist가 프로젝트 관리의 용이성이 주된 목표인데 혼자 프로젝트를 진행하다보니 크게 와닿는 점은 없었다. 아쉽지만 다음 팀 프로젝트에 적용해보고 몸소 느껴봤음 좋겠다.

<br>

