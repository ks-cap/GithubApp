import ComposableArchitecture
import GithubAPI

@Reducer
public struct UsersReducer {
    public init() {}

    @Reducer
    public enum Destination {
        case alert(AlertState<Never>)
        case user(UserReducer)
    }

    @ObservableState
    public struct State {
        var users: [UserSummary] = []
        @Presents var destination: Destination.State?
        @Presents var user: UserReducer.State?
        
        public init() {}
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case userTapped(UserSummary)
        case fetch(lastUserId: Int? = nil)
        case fetchResponse(Result<[UserSummary], Error>)
        case refresh
        case refreshResponse(Result<[UserSummary], Error>)
    }
    
    @Dependency(\.githubClient) var githubClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination:
                return .none

            case .userTapped(let user):
                state.destination = .user(UserReducer.State(username: user.username))
                return .none

            case .fetch(let lastUserId):
                return .run { send in
                    await send(.fetchResponse(
                        Result {
                            try await self.githubClient.fetchUsers(lastUserId)
                        }
                    ))
                }

            case .fetchResponse(.success(let users)):
                if state.users.isEmpty {
                    state.users = users
                } else {
                    state.users.append(contentsOf: users)
                }
                return .none

            case .refresh:
                return .run { send in
                    await send(.refreshResponse(
                        Result { try await self.githubClient.fetchUsers(nil) }
                    ))
                }

            case .refreshResponse(.success(let users)):
                state.users = users
                return .none

            case .fetchResponse(.failure(let error)), .refreshResponse(.failure(let error)):
                state.destination = .alert(
                    AlertState {
                        TextState(error.localizedDescription)
                    }
                )
                return .none
            }
        }
    }
}
