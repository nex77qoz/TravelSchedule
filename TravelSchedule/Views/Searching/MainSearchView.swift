import SwiftUI

struct MainSearchView: View {
    @Binding var navPath: [ViewsChanger]
    @ObservedObject var rootViewModel: MainViewModel
    @ObservedObject var viewModel: SearchScreenViewModel

    var body: some View {
        VStack(spacing: 0) {
            searchWidget
            if viewModel.isSearchButtonReady {
                NavigationLink(value: ViewsChanger.threadView) {
                    Text(Constants.searchButtonTitle)
                        .setCustomButton(width: 150, padding: .all)
                }
                .padding(.top, .M)
            }
            Spacer()
        }
    }
}

private extension MainSearchView {
    enum Constants {
        static let searchButtonTitle = "Найти"
        static let dummyDirection = ["Откуда", "Куда"]
        static let widgetSpacing: CGFloat = .L
        static let widgetPadding: CGFloat = .L
        static let widgetTopPadding: CGFloat = .XL
        static let widgetHeight: CGFloat = 128
        static let cornerRadius: CGFloat = .XL
        static let swapButtonSize: CGFloat = 36
        static let destinationsSpacing: CGFloat = 0
        static let destinationHeight: CGFloat = 128
    }

    var searchWidget: some View {
        HStack(alignment: .center, spacing: Constants.widgetSpacing) {
            destinationsList
            swapButton
        }
        .padding(Constants.widgetPadding)
        .background(Color.ypBlue)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .frame(height: Constants.widgetHeight)
        .padding(.top, Constants.widgetTopPadding)
        .padding(.horizontal, Constants.widgetPadding)
    }

    var swapButton: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.ypWhite)
                .frame(width: Constants.swapButtonSize)
            Button {
                viewModel.swapDestinations()
            } label: {
                Image.iconSearchSwap
                    .foregroundStyle(Color.ypBlue)
            }
        }
    }

    var destinationsList: some View {
        ZStack {
            VStack(alignment: .leading, spacing: Constants.destinationsSpacing) {
                ForEach(viewModel.destinations.indices, id: \.self) { index in
                    let destination = viewModel.destinations[index]
                    let city = destination.city.title
                    let stationTitle = destination.station.title
                    let label = city.isEmpty
                        ? Constants.dummyDirection[index]
                        : city + (stationTitle.isEmpty ? "" : " (\(stationTitle))")

                    NavigationLink(value: ViewsChanger.cityView) {
                        HStack {
                            Text(label)
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
                        .frame(maxWidth: .infinity, maxHeight: Constants.destinationHeight)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { viewModel.setDirection(to: index) }
                    )
                }
            }
            .background(Color.ypWhite)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

            if rootViewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.ypBlackDuo))
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
