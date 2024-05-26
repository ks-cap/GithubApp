import ComposableArchitecture
import SwiftUI

struct UsersView: View {
    @Bindable var store: StoreOf<UsersReducer>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.users) { user in
                    UserSummaryView(user: user)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.userTapped(user))
                        }
                        .onAppear {
                            if check(user: user) {
                                store.send(.fetch(lastUserId: user.id))
                            }
                        }
                }
            }
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
            .navigationTitle("Github Users List")
            .refreshable {
                store.send(.refresh)
            }
        }
        .task {
            store.send(.fetch())
        }
        .sheet(
            item: $store.scope(state: \.destination?.user, action: \.destination.user)
        ) { store in
            NavigationStack {
                UserView(store: store)
            }
        }
    }
    
    private func check(user: UserSummary) -> Bool {
        store.users.last?.id == user.id
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
