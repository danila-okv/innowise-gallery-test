import Foundation

final class NetworkService: NetworkServiceProtocol {
    let session: URLSession
    let decoder: JSONDecoder
    
    private enum Constants {
        static let baseURL = "https://api.unsplash.com"
        static let photoPath = "/photos"
    }
    
    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo] {
        guard var components = URLComponents(string: Constants.baseURL + Constants.photoPath) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            "Client-ID \(AppConfig.unsplashAccessKey)",
            forHTTPHeaderField: "Authorization"
        )
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode([Photo].self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
