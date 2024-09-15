import Common
import ComposableArchitecture
import Core

@Reducer
public struct UsersReducer {
    @ObservableState
    public struct State {
        var viewState: AsyncLoadingState<[User]> = .loading
        
        public init() {}
    }
    
    public enum Action {
        public enum Delegate {
          case userTapped(User)
        }

        case delegate(Delegate)
        case onAppear
        case fetch
        case fetched(Result<[User], Error>)
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

            case .fetch:
                state.viewState = .loading
                
                return .run { send in
                    let users = try await githubClient.fetchUsers()
                    await send(.fetched(.success(users)))
                } catch: { error, send in
                    await send(.fetched(.failure(error)))
                }
               
            case let .fetched(result):
                switch result {
                case let .success(users):
                    state.viewState = .success(users)
                    return .none
                    
                case .failure:
                    state.viewState = .failure
                    return .none
                }
            }
        }
    }
}
