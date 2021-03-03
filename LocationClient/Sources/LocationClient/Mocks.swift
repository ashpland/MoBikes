import Combine
import CoreLocation

extension LocationClient {
    public static var authorizedWhenInUse: Self {
        let subject = PassthroughSubject<DelegateEvent, Never>()
        
        return Self(
            authorizationStatus: { .authorizedWhenInUse },
            requestWhenInUseAuthorization: { },
            requestLocation: {
                subject.send(.didUpdateLocations([CLLocation()]))
            },
            delegate: subject.eraseToAnyPublisher()
        )
    }
    
    public static var notDetermined: Self {
        var status = CLAuthorizationStatus.notDetermined
        let subject = PassthroughSubject<DelegateEvent, Never>()
        
        return Self(
            authorizationStatus: { status },
            requestWhenInUseAuthorization: {
                status = .authorizedWhenInUse
                subject.send(.didChangeAuthorization(status))
            },
            requestLocation: {
                subject.send(.didUpdateLocations([CLLocation()]))
            },
            delegate: subject.eraseToAnyPublisher()
        )
    }
}

extension LocationClient {
    public static let sampleNear = CLLocation(latitude: 49.26307047497602,
                                              longitude: -123.11455871130153)
    public static let sampleFar  = CLLocation(latitude: 49.29235477443431,
                                              longitude: -123.13665159634905)
}
