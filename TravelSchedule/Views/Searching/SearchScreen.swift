import SwiftUI

struct SearchScreen: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var rootViewModel: MainViewModel
    @ObservedObject var viewModel: SearchScreenViewModel

    var body: some View {
        VStack(spacing: .zero) {
            PreviewStoriesView()
            MainSearchView(
                navPath: $navPath,
                rootViewModel: rootViewModel,
                viewModel: viewModel
            )
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SearchScreen(
            navPath: .constant([]),
            rootViewModel: MainViewModel(networkService: NetworkService()),
            viewModel: SearchScreenViewModel()
        )
    }
}
