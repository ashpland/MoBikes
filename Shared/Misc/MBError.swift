import Foundation

enum MBError: Error  {
    case statusNotOk(Int)
    case reponseNotHTTPURLResponse
    case decoderError
    case resourceNotFound(String)
    case unknownError(Error)
}

extension MBError {
    static func from(error: Error) -> MBError {
        if let mbError = error as? MBError {
            return mbError
        } else {
            return MBError.unknownError(error)
        }
    }
    
    var userDescription: String {
        switch self {
        case .statusNotOk, .reponseNotHTTPURLResponse, .decoderError:
            return "Updating Stations Failed"
        case .resourceNotFound(let resource):
            return "Unable to load \(resource)"
        case .unknownError:
            return "Unknown Error"
        }
    }
    
    var debugDescription: String {
        switch self {
        case .statusNotOk(let code): 
            return "Network Status Code \(code)"
        case .decoderError: 
            return "Could not decode API response"
        case .reponseNotHTTPURLResponse: 
            return "Response was not an HTTPURLResponse"
        case .resourceNotFound(let resource):
            return "Unable to load \(resource)"
        case .unknownError(let unknown): 
            return "Unknown Error \(unknown.localizedDescription)"
        }
    }
}
