import SwiftUI
import SVGKit
import Kingfisher

actor ImageDownloader: Sendable {
    private var cacheStorage: [String: Image]

    init(cache: [String: Image] = [:]) {
        self.cacheStorage = cache
    }

    func fetchSvgImage(from urlString: String) async -> Image? {
        if let cachedImage = cacheStorage[urlString] {
            return cachedImage
        }

        do {
            guard let url = URL(string: urlString) else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let svgImage = SVGKImage(data: data) else {
                return nil
            }
            let resized = Image(uiImage: svgImage.uiImage).resizable()
            cacheStorage[urlString] = resized
            return resized
        } catch {
            return nil
        }
    }

    func fetchImage(from urlString: String) async -> Image? {
        if let cachedImage = cacheStorage[urlString] {
            return cachedImage
        }

        do {
            guard let url = URL(string: urlString) else {
                return nil
            }
            let image = try await withCheckedThrowingContinuation { continuation in
                KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
                    switch result {
                        case .success(let kfResult):
                            continuation.resume(returning: kfResult.image)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                    }
                }
            }
            let downloaded = Image(uiImage: image).resizable()
            cacheStorage[urlString] = downloaded
            return downloaded
        } catch {
            return nil
        }
    }
}
