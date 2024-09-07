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
                        let gitHubPAT: String? = nil
                        dependency.userClient = .live(token: gitHubPAT)
                    }
                }
            )
        }
    }
}
