import CoreLocation

struct LocationClient {
    var initialize: (@escaping Dispatch) -> Void
    
    typealias Dispatch = (Event) -> Void
    enum Event {
        case updateLocation(Coordinate)
        case error(LocationError)
    }
}

enum LocationError: Error, Hashable {
    case notAuthorized(String)
    case locationUnknown
    case unknownError(CLError)
    
    var userDescription: String {
        switch self {
        case .notAuthorized:
            return "Location Services are not authorized"
        case .locationUnknown:
            return "Unable to find your location"
        case .unknownError:
            return "Unknown Location Error"
        }
    }
    
    var debugDescription: String {
        switch self {
        case .notAuthorized(let reason):
            return reason
        case .locationUnknown:
            return "Location Unknown"
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
    
}

extension LocationClient {
    static var live: Self {
        class Delegate: NSObject, CLLocationManagerDelegate {
            let dispatch: Dispatch
            
            init(_ dispatch: @escaping Dispatch) {
                self.dispatch = dispatch
            }

            func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                switch manager.authorizationStatus {
                case .notDetermined:
                    manager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    manager.startUpdatingLocation()
                case .restricted:
                    dispatch(.error(.notAuthorized("Location Authorization Restricted")))
                case .denied:
                    dispatch(.error(.notAuthorized("Location Authorization Denied")))
                @unknown default:
                    dispatch(.error(.notAuthorized("Location Authorization Unknown")))
                }
            }

            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                if let coordinate = Coordinate(locations) {
                    dispatch(.updateLocation(coordinate))
                }
            }
            
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                if let error = error as? CLError {
                    switch error.code {
                    case .denied:
                        dispatch(.error(.notAuthorized("Location Authorization Denied Error")))
                    case .locationUnknown:
                        dispatch(.error(.locationUnknown))
                    default:
                        dispatch(.error(.unknownError(error)))
                    }
                }
            }
        }
        

        func initialize(_ dispatch: @escaping Dispatch) {
            let locationManager = CLLocationManager()
            let delegate = Delegate(dispatch)
            locationManager.delegate = delegate
            locationManager.distanceFilter = 10
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        return Self(initialize: initialize)
    }
}

extension LocationClient {
    static var lostLagoon: Self {
        return Self(initialize: { $0(.updateLocation(.lostLagoon)) })
    }
    
    static var cityHall: Self {
        return Self(initialize: { $0(.updateLocation(.cityHall)) })
    }
    
    static var authorized: Self {
        return Self(initialize: { _ in } )
    }
    
    static var notAuthorized: Self {
        return Self(initialize: { $0(.error(.notAuthorized("Location Authorization Denied"))) })
    }
}
