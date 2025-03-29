import SwiftUI

struct ErrorView: View {
    @State var errorType: ErrorType

    var body: some View {
        Image(errorType.imageName)
        Text(errorType.description)
            .font(.boldMedium)
    }
}

#Preview {
    ErrorView(errorType: ErrorType.serverError)
}
