import ComposableArchitecture
import SwiftUI

struct UserView: View {
    @Bindable var store: StoreOf<UserReducer>
    
    var body: some View {
        EmptyView()
    }
}
