protocol NetworkRequestConfigurator {
    var baseURL: NetworkBaseURL { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var parameters: [String: Any] { get }
    var hearders: [String: String] { get }
}

extension NetworkRequestConfigurator {
    var baseURL: NetworkBaseURL {
        .rapidapi
    }
    
    var path: String {
        ""
    }
    
    var method: NetworkMethod {
        .get
    }
    
    var parameters: [String: Any] {
        [:]
    }
    
    var hearders: [String: String] {
        [
            "x-rapidapi-host": "yahoo-finance15.p.rapidapi.com",
            "x-rapidapi-key": "8853a9475amsh665d35ba2d84eaep18acbcjsn50ad5ffcca63"
        ]
    }
}
