import SwiftUI

struct StationScreen: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: StationScreenViewModel

    var body: some View {
        VStack(spacing: .zero) {
            searchBar
            if viewModel.filteredStations.isEmpty {
                emptyView
            } else {
                stationsList
            }
            Spacer()
        }
        .setCustomNavigationBar(title: viewModel.title)
        .foregroundStyle(Color.ypBlackDuo)
        .task {
            fetchData()
        }
        .overlay {
            if viewModel.state == .loading {
                progressView
            }
        }
    }
}

private extension StationScreen {
    var searchBar: some View {
        SearchBarView(searchText: $viewModel.searchString)
    }

    var emptyView: some View {
        SearchResultEmptyView(notification: viewModel.notification)
    }

    var stationsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: .zero) {
                ForEach(viewModel.filteredStations) { station in
                    Button {
                        saveSelected(station: station)
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

    var progressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
    }
}

private extension StationScreen {
    func saveSelected(station: Station) {
        destinationsViewModel.saveSelected(station: station)
        returnToRoot()
    }

    func returnToRoot() {
        navPath.removeAll()
    }

    func fetchData() {
        viewModel.searchString = String()
        viewModel.fetchStations()
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
