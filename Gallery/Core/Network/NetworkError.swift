import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case unexpectedStatusCode(Int)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .requestFailed:
            return "Network request failed. Check your connection."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .unexpectedStatusCode(let code):
            return "Server returned an unexpected status code (\(code))."
        case .decodingFailed:
            return "Failed to process the server response."
        }
    }
}
