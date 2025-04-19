import SwiftUI

struct CityView: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: CityViewViewModel

    var body: some View {
        VStack(spacing: .zero) {
            SearchBarView(searchText: $viewModel.searchString)

            if viewModel.filteredCities.isEmpty {
                SearchResultEmptyView(notification: viewModel.notification)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: .zero) {
                        ForEach(viewModel.filteredCities) { city in
                            NavigationLink(value: ViewsChanger.stationView) {
                                RowView(title: city.title)
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { destinationsViewModel.saveSelected(city: city) }
                            )
                            .setRowElement()
                            .padding(.vertical, .L)
                        }
                    }
                    .padding(.vertical, .L)
                }
            }
        }
        .setCustomNavigationBar(title: viewModel.title)
        .foregroundStyle(Color.ypBlackDuo)
        .task {
            viewModel.searchString = String()
            viewModel.fetchCities()
        }
        .overlay {
            if viewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
        }
    }
}

#Preview {
    NavigationStack {
        CityView(
            navPath: .constant([]),
            destinationsViewModel: SearchScreenViewModel(destinations: Destination.mockData),
            viewModel: CityViewViewModel(store: [])
        )
    }
}
