import ComposableArchitecture
import SwiftUI

public struct UserView: View {
    @Bindable var store: StoreOf<UserReducer>
    
    public var body: some View {
        EmptyView()
    }
}
