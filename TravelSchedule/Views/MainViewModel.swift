import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case error
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var currentError: ErrorType = .serverError
    @Published var navPath: [ViewsChanger] = []
    @Published private(set) var store: [Components.Schemas.Settlements] = []

    private let networkService: NetworkService
    private(set) var stationsDownloader: StationsDownloader
    private(set) var routesDownloader: ThreadDownloader
    private(set) var imageDownloader: ImageDownloader

    init(networkService: NetworkService) {
        self.networkService = networkService
        self.stationsDownloader = StationsDownloader(networkServiceInstance: networkService)
        self.routesDownloader = ThreadDownloader(networkServiceInstance: networkService)
        self.imageDownloader = ImageDownloader()
    }

    func fetchData() throws {
        Task {
            state = .loading
            do {
                store = try await stationsDownloader.fetchData()
                state = .loaded
            } catch {
                currentError = error.localizedDescription.contains("error 0.") ? .serverError : .connectionError
                state = .error
                throw currentError == .serverError ? ErrorType.serverError : ErrorType.connectionError
            }
        }
    }
}
