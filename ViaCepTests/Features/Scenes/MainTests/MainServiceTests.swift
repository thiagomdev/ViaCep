import Testing
import Foundation
import ViaCep

@Suite(.serialized)
final class MainServiceTests: LeakTrackerSuite {

    @Test(arguments: [DataCep.fixture()])
    func fetch_data_cep_success(fixture: DataCep) async throws {
        let (sut, networkingSpy) = makeSut()
        networkingSpy.expected = .success(fixture)
        
        do {
            let result = try await withCheckedThrowingContinuation { continuation in
                sut.fetchDataCep("0000-000") { result in
                    switch result {
                    case let .success(cep):
                        continuation.resume(returning: cep)
                        case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            #expect(networkingSpy.executeCalled == true)
            #expect(networkingSpy.executeCount == 1)
            #expect(result == .fixture())
            
        } catch {
            Issue.record("Expected to succeed, but failed due to error: \(error)")
        }
    }
}

extension MainServiceTests {
    private func makeSut(
        source: SourceLocation = #_sourceLocation) -> (sut: MainService, networkingSpy: NetworkingSpy) {
        let networkingSpy = NetworkingSpy()
        let sut = MainService(networking: networkingSpy)
        
        track(sut, source: source)
        track(networkingSpy, source: source)
        
        return (sut, networkingSpy)
    }
}
