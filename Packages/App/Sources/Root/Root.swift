import ComposableArchitecture
import SwiftUI
import Users

@Reducer
public struct RootReducer {
    public init() {}

    @Reducer
    public enum Path {}

    @ObservableState
    public struct State {
        var users: UsersReducer.State = .init()
        var path = StackState<Path.State>()
    }
    
    public enum Action {
        case users(UsersReducer.Action)
        case path(StackActionOf<Path>)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.users, action: \.users) {
            UsersReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .users, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

public struct RootView: View {
    @Bindable var store: StoreOf<RootReducer>
    
    public init(store: StoreOf<RootReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            UsersView(store: store.scope(state: \.users, action: \.users))
        } destination: { store in
            switch store.case {
            default:
                fatalError()
            }
        }
    }
}
