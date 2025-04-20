import SwiftUI

struct MainTabView: View {
    @StateObject var destinationsViewModel: SearchScreenViewModel
    @StateObject var rootViewModel: MainViewModel

    var body: some View {
        NavigationStack(path: $rootViewModel.navPath) {
            TabView {
                searchScreenTab
                settingsScreenTab
            }
            .task {
                rootViewModel.fetchData()
            }
            .sheet(isPresented: Binding(
                get: { rootViewModel.state == .error },
                set: { isPresenting in
                }
            )) {
                errorView
            }
            .accentColor(Color.ypBlackDuo)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: ViewsChanger.self) { pathValue in
                switch pathValue {
                case .cityView:
                    CityView(
                        navPath: $rootViewModel.navPath,
                        destinationsViewModel: destinationsViewModel,
                        viewModel: CityViewViewModel(store: rootViewModel.store)
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .stationView:
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
                case .threadView:
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
}

#Preview {
    MainTabView(
        destinationsViewModel: SearchScreenViewModel(),
        rootViewModel: MainViewModel(networkService: NetworkService())
    )
    .environmentObject(SettingsViewModel(networkService: NetworkService()))
}
