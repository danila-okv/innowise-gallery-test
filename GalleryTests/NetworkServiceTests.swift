import Testing
import Foundation
@testable import Gallery

struct NetworkServiceTests {
    init() {
        MockURLProtocol.requestHandler = nil
    }
    
    private func makeMockedSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
    
    @Test("fetchPhotos decodes success returns parsed Photos array")
    func fetchPhotosReturnsParsedPhotos() async throws {
        let json = """
        [
          {
            "id": "abc123",
            "description": null,
            "alt_description": "Test photo",
            "created_at": "2026-03-12T16:24:21Z",
            "urls": { "full": "f", "regular": "r", "small": "s" },
            "user": { "name": "Test Author" }
          }
        ]
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }
        
        let service = NetworkService(session: makeMockedSession(), accessKey: "test-key")
        
        let photos = try await service.fetchPhotos(page: 1, perPage: 30)
        
        #expect(photos.count == 1)
        
        let photo = try #require(photos.first)
        #expect(photo.id == "abc123")
        #expect(photo.urls.regular == "r")
        #expect(photo.user.name == "Test Author")
    }
}
