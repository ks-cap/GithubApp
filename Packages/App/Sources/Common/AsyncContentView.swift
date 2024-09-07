import SwiftUI

public enum AsyncLoadingState<T: Equatable>: Equatable {
    case loading
    case success(T)
    case failure
}

public struct AsyncContentView<T: Equatable, Success: View>: View {
    let state: AsyncLoadingState<T>
    let success: (T) -> Success
    let onRetryTapped: (() -> Void)?
    
    public init(
        state: AsyncLoadingState<T>,
        @ViewBuilder success: @escaping (T) -> Success,
        onRetryTapped: (() -> Void)? = nil
    ) {
        self.state = state
        self.success = success
        self.onRetryTapped = onRetryTapped
    }
    
    public var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case .success(let data):
            success(data)
        case .failure:
            FailureView(onRetryTapped: onRetryTapped)
        }
    }
}

private extension AsyncContentView {
    struct FailureView: View {
        let onRetryTapped: (() -> Void)?
        
        var body: some View {
            VStack {
                Image(systemName: "cloud.rain")
                    .font(.system(size: 120))
                    .foregroundStyle(.cyan.opacity(0.4))
                
                Text("Something went wrong. Please try again.")
                    .multilineTextAlignment(.center)
                
                if let onRetryTapped {
                    Button(action: onRetryTapped) {
                        Label(
                            title: { Text("Retry") },
                            icon: { Image(systemName: "arrow.counterclockwise") }
                        )
                    }
                    .buttonStyle(.bordered)
                    .fontWeight(.medium)
                }
            }
            .padding()
        }
    }
}

#Preview("Loading") {
    AsyncContentView(state: AsyncLoadingState<String>.loading) { _ in
        Text("Success")
    }
}

#Preview("Success") {
    AsyncContentView(state: AsyncLoadingState<String>.success("Success")) { data in
        Text(data)
    }
}
