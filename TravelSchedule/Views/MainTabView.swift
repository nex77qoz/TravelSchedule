import SwiftUI

struct MainTabView: View {
    @State private var isError: Bool = false
    @StateObject var destinationsViewModel: SearchScreenViewModel
    @StateObject var rootViewModel: MainViewModel

    var body: some View {
        NavigationStack(path: $rootViewModel.navPath) {
            TabView {
                searchScreenTab
                settingsScreenTab
            }
            .task {
                do {
                    try await rootViewModel.fetchData()
                } catch {
                    isError = true
                }
            }
            .sheet(isPresented: $isError) {
                isError = false
            } content: {
                errorView
            }
            .accentColor(Color.ypBlackDuo)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: ViewsChanger.self) { pathValue in
                switch pathValue {
                case .cityView:
                    citiesScreen
                case .stationView:
                    stationsScreen
                case .threadView:
                    threadsScreen
                }
            }
        }
    }

    var searchScreenTab: some View {
        SearchScreen(
            navPath: $rootViewModel.navPath,
            rootViewModel: rootViewModel,
            viewModel: destinationsViewModel
        )
        .tabItem {
            Image.iconTabSearch
        }
    }

    var settingsScreenTab: some View {
        SettingsScreen()
            .tabItem {
                Image.iconTabSettings
            }
    }

    var errorView: some View {
        ErrorView(errorType: rootViewModel.currentError)
    }

    var citiesScreen: some View {
        CityView(
            navPath: $rootViewModel.navPath,
            destinationsViewModel: destinationsViewModel,
            viewModel: CityViewViewModel(store: rootViewModel.store)
        )
        .toolbar(.hidden, for: .tabBar)
    }

    var stationsScreen: some View {
        StationScreen(
            navPath: $rootViewModel.navPath,
            destinationsViewModel: destinationsViewModel,
            viewModel: StationScreenViewModel(
                store: rootViewModel.store,
                city: destinationsViewModel.destinations[
                    destinationsViewModel.direction
                ].city
            )
        )
        .toolbar(.hidden, for: .tabBar)
    }

    var threadsScreen: some View {
        ThreadsScreen(
            viewModel: ThreadsScreenViewModel(
                destinations: destinationsViewModel.destinations,
                routesDownloader: rootViewModel.routesDownloader,
                imageDownloader: rootViewModel.imageDownloader
            )
        )
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    MainTabView(
        destinationsViewModel: SearchScreenViewModel(),
        rootViewModel: MainViewModel(networkService: NetworkService())
    )
    .environmentObject(SettingsViewModel(networkService: NetworkService()))
}
