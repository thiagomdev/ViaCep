import Foundation

public final class Tasking<T: Codable>: Task {
    public let request: Request

    private let httpClient: HTTPClient
    private let callback: ((Result<T, Error>) -> Void)?
    private var task: HTTPClientTask?
    private let responseType: T.Type

    public init(
        request: Request,
        callback: ((Result<T, Error>) -> Void)?,
        responseType: T.Type,
        httpClient: HTTPClient = URLSessionHTTPClient()
    ) {
        self.request = request
        self.callback = callback
        self.responseType = responseType
        self.httpClient = httpClient
    }

    public func resume() {
        guard let url = URL(string: request.url) else { return }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.request.headers
        request.httpMethod = self.request.method.description
        request.httpBody = self.request.body

        task = httpClient.execute(
            request,
            completion: { [weak self] data, response, error in
                self?.logger(request: request, response: response, data: data, error: error)
            if let error {
                self?.callback?(.failure(error))
                return
            }
            
                if let error {
                    self?.callback?(.failure(error))
                }
                
                guard let data,
                    let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                
                if self?.responseType is EmptyResponse.Type, let decoded = EmptyResponse() as? T {
                    self?.callback?(.success(decoded))
                } else {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        self?.callback?(.success(decoded))
                        
                    } catch {
                        self?.callback?(
                            .failure(
                                NetworkError.responseError(
                                    data, httpResponse.statusCode
                                )
                            )
                        )
                    }
                }
            })
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    private func logger(request: URLRequest?, response: URLResponse?, data: Data?, error: Error?) {
        NetworkingLogger.log(request: request, response: response, data: data, error: error, verbose: true)
    }
}
