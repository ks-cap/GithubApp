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
        AsyncContentView(state: store.contentState) { users in
            List {
                ForEach(users) { user in
                    Button {
                      store.send(.delegate(.userTapped(user)))
                    } label: {
                        UserSummaryView(user: user)
                    }
                }
            }
            .refreshable {
                store.send(.refresh)
            }
        } onRetryTapped: {
            store.send(.retryTapped)
        }
        .task {
            await store.send(.onAppear).finish()
        }
        .navigationTitle("Github Users List")
    }
}

private struct UserSummaryView: View {
    let user: UserSummary

    var body: some View {
        HStack {
            AsyncImage(url: .init(string: user.avatarImage)!) {
                $0.image?.resizable()
            }
            .clipShape(Circle())
            .frame(width: 50, height: 50)

            Text(user.username)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
