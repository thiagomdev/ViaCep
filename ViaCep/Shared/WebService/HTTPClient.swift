import Foundation

public protocol HTTPClientTask {
    func resume()
    func cancel()
}

extension URLSessionDataTask: HTTPClientTask {}

public protocol HTTPClient {
    func execute(
        _ request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPClientTask
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func execute(
        _ request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPClientTask {
        session.dataTask(with: request, completionHandler: completion)
    }
}
