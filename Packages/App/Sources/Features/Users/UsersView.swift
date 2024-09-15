import Common
import ComposableArchitecture
import Core
import SwiftUI

public struct UsersView: View {
    @Bindable var store: StoreOf<UsersReducer>
    
    public init(store: StoreOf<UsersReducer>) {
      self.store = store
    }

    public var body: some View {
        AsyncContentView(state: store.viewState) { users in
            List {
                ForEach(users) { user in
                    Button {
                      store.send(.delegate(.userTapped(user)))
                    } label: {
                        UserView(user: user)
                    }
                }
            }
        } onRetryTapped: {
            store.send(.retryTapped)
        }
        .task {
            store.send(.onAppear)
        }
        .navigationTitle("Github Users List")
    }
}

private struct UserView: View {
    let user: User

    var body: some View {
        HStack {
            AvatarView(url: user.avatarUrl)
            .frame(width: 50, height: 50)

            Text(user.userName)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct AvatarView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .clipShape(Circle())
    }
}
