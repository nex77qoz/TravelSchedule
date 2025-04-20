import SwiftUI

struct StationScreen: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: StationScreenViewModel

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $viewModel.searchString)

            if viewModel.filteredStations.isEmpty {
                SearchResultEmptyView(notification: viewModel.notification)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredStations) { station in
                            Button {
                                destinationsViewModel.saveSelected(station: station)
                                navPath.removeAll()
                            } label: {
                                RowView(title: station.title)
                            }
                            .setRowElement()
                            .padding(.vertical, .L)
                        }
                    }
                    .padding(.vertical, .L)
                }
            }

            Spacer()
        }
        .setCustomNavigationBar(title: viewModel.title)
        .foregroundStyle(Color.ypBlackDuo)
        .task {
            viewModel.searchString = ""
            viewModel.fetchStations()
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
        StationScreen(
            navPath: .constant([]),
            destinationsViewModel: SearchScreenViewModel(destinations: Destination.mockData),
            viewModel: StationScreenViewModel(store: [], city: City.mockData[0])
        )
    }
}
