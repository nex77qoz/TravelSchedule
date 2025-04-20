import SwiftUI

struct CityView: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: CityViewViewModel

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $viewModel.searchString)

            if viewModel.filteredCities.isEmpty {
                SearchResultEmptyView(notification: CityViewViewModel.Constants.notification)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
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
        .setCustomNavigationBar(title: CityViewViewModel.Constants.title)
        .foregroundStyle(Color.ypBlackDuo)
        .task {
            viewModel.searchString = ""
            viewModel.fetchCities()
        }
        .overlay {
            if viewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.ypBlackDuo))
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
