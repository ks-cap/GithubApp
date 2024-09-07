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
        
        public init() {}
    }
    
    public enum Action {
        case users(UsersReducer.Action)
        case path(StackActionOf<Path>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .users, .path:
                return .none
            }
        }
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
