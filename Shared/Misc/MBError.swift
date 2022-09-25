import Foundation

enum MBError: Error, Identifiable, Hashable  {
    case decoderError
    case locationError(LocationError)
    case reponseNotHTTPURLResponse
    case resourceNotFound(name: String)
    case statusNotOk(status: Int)
    case unknownError(description: String)
    
    var id: Self {
        return self
    }
}

extension MBError {
    static func from(error: Error) -> MBError {
        if let mbError = error as? MBError {
            return mbError
        } else {
            return MBError.unknownError(description: error.localizedDescription)
        }
    }
    
    var userDescription: String {
        switch self {
        case .statusNotOk, .reponseNotHTTPURLResponse, .decoderError:
            return "Updating Stations Failed"
        case .resourceNotFound(let resource):
            return "Unable to load \(resource)"
        case .locationError(let error):
            return error.userDescription
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
        case .locationError(let error):
            return error.debugDescription
        case .unknownError(let description):
            return "Unknown Error \(description)"
        }
    }
}
