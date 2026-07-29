import Foundation

public enum MainAPIRequest: Request {
    case cep(String)
    
    public var endpoint: String {
        switch self {
        case let .cep(cep):
            return "/\(cep)/json/"
        }
    }
    
    public var method: HttpMethod { .get }
    
    public var headers: [String : String]? { nil }
    public var body: Data? { nil }
    public var parameters: [String : String]? { nil }
}
