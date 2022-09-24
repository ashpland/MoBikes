import Foundation

let dataRequestForURL: (URL) async throws -> (Data, URLResponse) = { url in
    try await URLSession.shared.data(from: url, delegate: nil)
}

func checkStatus(_ args: (data: Data, response: HTTPURLResponse?)) throws -> Data {
    switch args.response {
    case .some(let response) where response.statusCode == 200:
        return args.data
    case .some(let response):
        throw MBError.statusNotOk(response.statusCode)
    case .none:
        throw MBError.reponseNotHTTPURLResponse
    }
}

func decode<T: Decodable>(_ type: T.Type) -> (Data) throws -> T {
    curry(JSONDecoder().decode(_:from:))(type)
}
