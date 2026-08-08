import ViaCep
import Testing
import Foundation

@Suite(.serialized)
final class MainInteractorTests: MemoryLeakTrackingSuite {
    @Test
    func display_cep_success() {
        let (sut, doubles) = makeSut()
        doubles.serviceSpy.expectedResponse = .success(.fixture())
        
        sut.displayCep("0000-000")

        #expect(doubles.presenterSpy.messages == [.presentCep(cep: .fixture(cep: "0000-000"))])
    }
    
    @Test
    func display_cep_failure() {
        let (sut, doubles) = makeSut()
        
        let samples = [199, 201, 300, 400, 500].enumerated()
        let error = NSError(
            domain: "Wainting for a request conclusion",
            code: samples.underestimatedCount
        )
        
        doubles.serviceSpy.expectedResponse = .failure(error)
        
        sut.displayCep("01150011")
        
        samples.forEach { _, _ in
            #expect(doubles.presenterSpy.messages == [.displayError(message: error.localizedDescription)])
        }
    }
    
    @Test
    func clear_text() {
        let (sut, _) = makeSut()
        
        let clearString = sut.clearText()
        
        #expect(clearString == nil)
    }
}

extension MainInteractorTests {
    private typealias Doubles = (
        presenterSpy: MainPresenterSpy,
        serviceSpy: ServiceMock
    )
    
    private func makeSut(source: SourceLocation = #_sourceLocation) -> (sut: MainInteractor, doubles: Doubles) {
        
        let serviceSpy = ServiceMock()
        let presenterSpy = MainPresenterSpy()
        let sut = MainInteractor(presenter: presenterSpy, service: serviceSpy)
            
        trackForMemoryLeak(sut, source: source)
        trackForMemoryLeak(presenterSpy, source: source)
        trackForMemoryLeak(serviceSpy, source: source)
            
        return (sut, (presenterSpy, serviceSpy))
    }
}
