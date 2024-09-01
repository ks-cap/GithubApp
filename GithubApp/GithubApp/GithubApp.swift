import Features
import SwiftUI

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
            UsersView(
                store: .init(initialState: UsersReducer.State()) {
                    UsersReducer()
                }
            )
        }
    }
}
