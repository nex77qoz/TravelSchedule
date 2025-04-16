import SwiftUI

struct MainSearchView: View {
    private let searchButtonTitle = "Найти"
    private let dummyDirection = ["Откуда", "Куда"]

    @Binding var navPath: [ViewsChanger]
    @ObservedObject var rootViewModel: MainViewModel
    @ObservedObject var viewModel: SearchScreenViewModel

    var body: some View {
        searchWidget
        if viewModel.isSearchButtonReady {
            searchButton
        }
        Spacer()
    }
}

// MARK: - Private views
private extension MainSearchView {
    var searchWidget: some View {
        HStack(alignment: .center, spacing: .L) {
            destinationsList
            swapButton
        }
        .padding(.L)
        .background(Color.ypBlue)
        .clipShape(RoundedRectangle(cornerRadius: .XL))
        .frame(height: 128.0)
        .padding(.top, .XL)
        .padding(.horizontal, .L)
    }

    var swapButton: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.ypWhite)
                .frame(width: 36.0)
            Button {
                viewModel.swapDestinations()
            } label: {
                Image.iconSearchSwap
                    .foregroundStyle(Color.ypBlue)
            }
        }
    }

    var searchButton: some View {
        NavigationLink(value: ViewsChanger.threadView) {
            Text(searchButtonTitle)
                .setCustomButton(width: 150.0, padding: .all)
        }
    }

    var destinationsList: some View {
        ZStack {
            VStack(alignment: .leading, spacing: .zero) {
                ForEach(Array(viewModel.destinations.enumerated()), id: \.offset) { index, destination in
                    let city = destination.city.title
                    let station = destination.station.title.isEmpty ? "" : " (" + destination.station.title + ")"
                    let destinationLabel = city.isEmpty
                    ? dummyDirection[index]
                    : city + station
                    return NavigationLink(value: ViewsChanger.cityView) {
                        HStack {
                            Text(destinationLabel)
                                .foregroundStyle(
                                    rootViewModel.state == .loading
                                    ? .clear
                                    : city.isEmpty
                                    ? Color.ypGray
                                    : Color.ypBlack
                                )
                            Spacer()
                        }
                        .padding(.L)
                        .frame(maxWidth: .infinity, maxHeight: 128.0)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { viewModel.setDirection(to: index) }
                    )
                }
            }
            .background(Color.ypWhite)
            .clipShape(RoundedRectangle(cornerRadius: .XL))
            if rootViewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainSearchView(
            navPath: .constant([]),
            rootViewModel: MainViewModel(networkService: NetworkService()),
            viewModel: SearchScreenViewModel(destinations: Destination.mockData)
        )
    }
}
