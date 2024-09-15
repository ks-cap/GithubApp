import ComposableArchitecture
import GithubAPI
import Root
import SwiftUI

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(initialState: RootReducer.State()) {
                    RootReducer().transformDependency(\.self) { dependency in
                        let token = Bundle.main.infoDictionary?["GithubAccessToken"] as? String
                        dependency.githubClient = .live(token: token)
                    }
                }
            )
        }
    }
}
