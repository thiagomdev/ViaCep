import Foundation
@testable import ViaCep

final class HTTPClientSpy: HTTPClient {
    private var messages = [(request: URLRequest, completion: (Data?, URLResponse?, Error?) -> Void)]()
    private(set) var canceledRequests = [URLRequest]()

    var requestedURLs: [URL] { messages.compactMap { $0.request.url } }

    func execute(
        _ request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPClientTask {
        messages.append((request, completion))
        return Task(request: request, spy: self)
    }

    func complete(withError error: Error, at index: Int = 0) {
        messages[index].completion(nil, nil, error)
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!

        messages[index].completion(data, response, nil)
    }

    private struct Task: HTTPClientTask {
        let request: URLRequest
        let spy: HTTPClientSpy

        func resume() {}

        func cancel() {
            spy.canceledRequests.append(request)
        }
    }
}
