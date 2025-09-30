struct TickersResponse: Decodable, Hashable {
    let body: [Body]
    
    struct Body: Decodable, Hashable {
        let symbol: String
        let name: String
        let lastsale: String
        let netchange: String
        let pctchange: String
    }
}
