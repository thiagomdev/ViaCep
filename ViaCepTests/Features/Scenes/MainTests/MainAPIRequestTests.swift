import XCTest
import ViaCep

final class MainAPIRequestTests: XCTestCase {
    func test_endpoint_when_endpoint_is_accessed_then_returns_correct_endpoint() {
        let (sut, _) = makeSut()
        
        let expectedEndpoint: String = "/01150011/json/"
        
        XCTAssertEqual(expectedEndpoint, sut.endpoint)
    }
    
    func test_http_method_when_http_method_is_accessed_then_returns_expected_http_method_get() {
        let (sut, _) = makeSut()
        
        let expectedHttpMethod = sut.method
        
        XCTAssertEqual(expectedHttpMethod, .get)
    }
    
    func test_parameters_when_expect_nil() {
        let (sut, _) = makeSut()
        
        let expectedParameters: [String: String]? = nil
        
        XCTAssertEqual(expectedParameters, sut.parameters)
    }
    
    func test_data_body_when_expect_nil() {
        let (sut, _) = makeSut()
        
        let data: Data? = nil
        
        XCTAssertEqual(data, sut.body)
    }
    
    func test_headers_when_expect_nil() {
        let (sut, _) = makeSut()
        
        let headers: [String : String]? = nil
        
        XCTAssertEqual(headers, sut.headers)
    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: MainAPIRequest, spy: MainRequestSpy) {
        let spy = MainRequestSpy()
        let sut = MainAPIRequest.cep("01150011")
        trackForMemoryLeaks(to: spy, file: file, line: line)
        return (sut, spy)
    }
    
    private final class MainRequestSpy: Request {
        var expectedEndpoint: String = ""
        var expectedHttpMethod: HttpMethod = .get
        var baseUrl: String { "" }
        
        var endpoint: String {
            return expectedEndpoint
        }
        
        var method: HttpMethod { expectedHttpMethod }
        
        var parameters: [String: String]? { nil }
        var headers: [String: String]? { nil }
        var body: Data? { nil }
    }
}
