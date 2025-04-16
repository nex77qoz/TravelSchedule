import SwiftUI

struct ThreadsScreen: View {
    @State private var isError: Bool = false
    @ObservedObject var viewModel: ThreadsScreenViewModel

    var body: some View {
        VStack(spacing: .zero) {
            titleView
            switch viewModel.state {
                case .loading:
                    loaderView
                case .none:
                    emptyView
                default:
                    routesList
            }
        }
        .padding(.horizontal, .L)
        .setCustomNavigationBar()
        .task {
            await fetchData()
        }
        .sheet(isPresented: $isError, onDismiss: {
            isError = false
        }, content: {
            ErrorView(errorType: viewModel.currentError)
        })
    }
}

private extension ThreadsScreen {
    var titleView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            (Text(viewModel.departure) + Text(Image.iconArrow).baselineOffset(-1) + Text(viewModel.arrival))
                .font(.boldMedium)
        }
    }

    var loaderView: some View {
        Spacer()
            .overlay {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
    }

    var emptyView: some View {
        SearchResultEmptyView(notification: viewModel.notification)
    }

    var routesList: some View {
        VStack(spacing: .zero) {
            routesView
            Spacer()
            buttonView
        }
    }

    var routesView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(viewModel.filteredRoutes) { route in
                if let carrier = viewModel.carriers.first(where: { $0.code == route.carrierCode }) {
                    NavigationLink {
                        CarrierView(carrier: carrier, imageDownloader: viewModel.imageDownloader)
                    } label: {
                        ThreadView(route: route, carrier: carrier, imageDownloader: viewModel.imageDownloader)
                    }
                }
            }
        }
        .padding(.top, .L)
    }

    var buttonView: some View {
        NavigationLink {
            FilterView(viewModelFilter: $viewModel.filter)
        } label: {
            buttonTitleView
        }
    }

    var buttonTitleView: some View {
        HStack(alignment: .center, spacing: .S) {
            Text(viewModel.buttonTitle)
            markerView
        }
        .setCustomButton(padding: .top)
    }

    var markerView: some View {
        Image.marker
            .resizable()
            .scaledToFit()
            .frame(width: .S, height: .S)
            .foregroundStyle(
                viewModel.filter == Filter.fullSearch ? Color.ypBlue : Color.ypRed
            )
    }
}

private extension ThreadsScreen {
    func fetchData() async {
        do {
            if viewModel.routes.isEmpty {
                try await viewModel.searchRoutes()
            }
        } catch {
            isError = true
        }
    }
}

#Preview {
    NavigationStack {
        ThreadsScreen(
            viewModel: ThreadsScreenViewModel(
                destinations: Destination.mockData,
                routes: Thread.mockData,
                routesDownloader: ThreadDownloader(networkServiceInstance: NetworkService()),
                imageDownloader: ImageDownloader()
            )
        )
    }
}
