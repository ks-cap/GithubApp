import ComposableArchitecture

@Reducer
struct UserReducer {
    @ObservableState
    struct State: Equatable {
        var username: String
    }
}
