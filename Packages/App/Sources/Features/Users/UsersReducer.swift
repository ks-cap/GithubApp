import Common
import ComposableArchitecture
import Core

@Reducer
public struct UsersReducer {
    @ObservableState
    public struct State {
        var contentState: AsyncLoadingState<[UserSummary]> = .loading
        
        public init() {}
    }
    
    public enum Action {
        public enum Delegate {
          case userTapped(UserSummary)
        }

        case delegate(Delegate)
        case onAppear
        case fetch
        case fetched(Result<[UserSummary], Error>)
        case refresh
        case retryTapped
    }
    
    @Dependency(\.githubClient) var githubClient
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .onAppear, .retryTapped:
                return .send(.fetch)

            case .fetch, .refresh:
                state.contentState = .loading
                
                return .run { send in
                    let users = try await githubClient.fetchUsers()
                    await send(.fetched(.success(users)))
                } catch: { error, send in
                    await send(.fetched(.failure(error)))
                }
               
            case let .fetched(result):
                switch result {
                case let .success(users):
                    state.contentState = .success(users)
                    return .none
                    
                case .failure:
                    state.contentState = .failure
                    return .none
                }
            }
        }
    }
}
