import Testing
import Foundation
@testable import ViaCep

@Suite(.serialized)
final class TaskingTests: MemoryLeakTrackingSuite {
    @Test
    func execute_requestsFromURL() {
        let request = RequestDummy()
        let (sut, client) = makeSUT(request: request)

        sut.resume()

        #expect(client.requestedURLs == [URL(string: request.url)])
    }

    @Test
    func execute_deliversErrorOnClientError() {
        var receivedResults = [Result<DataCep, Error>]()
        let (sut, client) = makeSUT(callback: { receivedResults.append($0) })

        sut.resume()
        client.complete(withError: NSError(domain: "any error", code: 0))

        guard case .failure? = receivedResults.first else {
            Issue.record("Expected failure result, got \(receivedResults)")
            return
        }
    }

    @Test
    func execute_deliversResponseErrorOnInvalidJSON() {
        var receivedResults = [Result<DataCep, Error>]()
        let (sut, client) = makeSUT(callback: { receivedResults.append($0) })
        let invalidJSON = Data("invalid json".utf8)

        sut.resume()
        client.complete(withStatusCode: 200, data: invalidJSON)

        guard case let .failure(error)? = receivedResults.first else {
            Issue.record("Expected failure result, got \(receivedResults)")
            return
        }

        guard let networkError = error as? NetworkError, case .responseError = networkError else {
            Issue.record("Expected NetworkError.responseError, got \(error)")
            return
        }
    }

    @Test
    func execute_deliversDecodedObjectOn200WithValidJSON() throws {
        var receivedResults = [Result<DataCep, Error>]()
        let (sut, client) = makeSUT(callback: { receivedResults.append($0) })
        let expected = DataCep.fixture()
        let validJSON = try JSONEncoder().encode(expected)

        sut.resume()
        client.complete(withStatusCode: 200, data: validJSON)

        guard case let .success(cep)? = receivedResults.first else {
            Issue.record("Expected success result, got \(receivedResults)")
            return
        }

        #expect(cep == expected)
    }
}

extension TaskingTests {
    private func makeSUT(
        request: Request = RequestDummy(),
        callback: @escaping (Result<DataCep, Error>) -> Void = { _ in },
        source: SourceLocation = #_sourceLocation
    ) -> (sut: Tasking<DataCep>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = Tasking<DataCep>(
            request: request,
            callback: callback,
            responseType: DataCep.self,
            httpClient: client
        )

        trackForMemoryLeak(sut, source: source)
        trackForMemoryLeak(client, source: source)

        return (sut, client)
    }
}
