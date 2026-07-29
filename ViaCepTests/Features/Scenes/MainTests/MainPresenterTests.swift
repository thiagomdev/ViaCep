import Testing
import Foundation
import ViaCep

@Suite(.serialized)
final class MainPresenterTests: LeakTrackerSuite {

    @Test
    func present_cep() {
        let (sut, viewControllerSpy) = makeSut()
        
        sut.presentCep(.fixture())
        
        #expect(viewControllerSpy.messages == [.didShowCep(.fixture())])
    }
    
    @Test
    func display_error() {
        let (sut, viewControllerSpy) = makeSut()
        let message: String = "Something was wrong..."
        
        sut.displayError(message)

        #expect(viewControllerSpy.messages == [.didShowError(message)])
    }
}

extension MainPresenterTests {
    private func makeSut(
        source: SourceLocation = #_sourceLocation) -> (sut: MainPresenter, viewControllerSpy: MainViewControllerSpy) {
                
        let viewControllerSpy = MainViewControllerSpy()
        let sut = MainPresenter()
        sut.mainView = viewControllerSpy
        
        track(sut, source: source)
        track(viewControllerSpy, source: source)

        return (sut, viewControllerSpy)
    }
}
