import SwiftUI

struct ErrorView: View {
    let errorType: ErrorType

    var body: some View {
        Image(errorType.imageName)
        Text(errorType.description)
            .font(.boldMedium)
    }
}

#Preview {
    ErrorView(errorType: ErrorType.connectionError)
}
