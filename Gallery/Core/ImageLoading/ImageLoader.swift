import UIKit

final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    private let session: URLSession
    private let cache = NSCache<NSString, UIImage>()
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ImageLoaderError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.decodingFailed
        }
        
        cache.setObject(image, forKey: key)
            
        return image
    }
}

enum ImageLoaderError: Error {
    case invalidResponse
    case decodingFailed
}
