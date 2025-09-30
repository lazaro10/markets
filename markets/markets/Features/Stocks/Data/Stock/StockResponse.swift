struct StockResponse: Decodable, Equatable {
    let meta: Meta
    let body: Body
    
    struct Meta: Decodable, Equatable {
        let symbol: String?
    }
    
    struct Body: Decodable, Equatable {
        let address1: String?
        let city: String?
        let state: String?
        let zip: String?
        let country: String?
        let sector: String?
        let industryDisp: String?
        let fullTimeEmployees: Double?
        let longBusinessSummary: String?
    }
}
