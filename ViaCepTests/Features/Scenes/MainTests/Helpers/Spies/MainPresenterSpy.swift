import Foundation
@testable import ViaCep

final class MainPresenterSpy: MainPresenting {
    enum Message: Hashable {
        case presentCep(cep: DataCep)
        case displayError(message: String)
    }

    enum ResultType {
        case success(Data, HTTPURLResponse)
        case failure(Error)
    }

    private var message = [(url: URL, completion: (ResultType) -> Void)]()

    var requestedURLs: [URL] { return message.map { $0.url } }

    private(set) var messages = [Message]()

    func presentCep(_ cep: DataCep) {
        messages.append(.presentCep(cep: cep))
    }

    func displayError(_ message: String) {
        messages.append(.displayError(message: message))
    }

    func complete(withError error: Error, at index: Int = 0) {
        message[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!

        message[index].completion(.success(data, response))
    }
}
