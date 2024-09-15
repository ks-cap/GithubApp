import ComposableArchitecture

@Reducer
public struct UserReducer {
    @ObservableState
    public struct State: Equatable {
        var userName: String
    }
}
