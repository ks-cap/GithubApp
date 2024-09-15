import Foundation

struct NetworkRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    let urlString: String
    let httpMethod: HTTPMethod
    let queryParameters: [String: String]
    let body: Data?
    let header: [String: String]
    
    init(
        urlString: String,
        httpMethod: HTTPMethod,
        queryParameters: [String : String] = [:],
        body: Data? = nil,
        header: [String : String] = [:]
    ) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.queryParameters = queryParameters
        self.body = body
        self.header = header
    }
    
    func build() throws -> URLRequest {
        let url = try constructUrl(urlString: urlString, queryParameters: queryParameters)
        var urlRequest = URLRequest(url: url)

        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = header
        urlRequest.timeoutInterval = TimeInterval(60)
        return urlRequest
    }
    
    private func constructUrl(urlString: String, queryParameters: [String: String]) throws -> URL {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        
        var queryItems = urlComponents.queryItems ?? []
        queryParameters.forEach {
            queryItems.append(.init(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }
        
        return url
    }
}
