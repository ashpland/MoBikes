import Foundation
import MapKit

class Bikeway: MKMultiPolyline {
    var category: Category?
    
    init(_ segments: [Segment]) {
        self.category = segments.first?.category
        super.init(segments)
    }
}

extension Bikeway {
    class Segment: MKPolyline {
        var category: Category?
        
        static func build(_ line: MKPolyline, _ category: Bikeway.Category) -> Segment {
            let segment = Bikeway.Segment(points: line.points(), count: line.pointCount)
            segment.category = category
            return segment
        }
    } 
    
    enum Category: String, Hashable {
        case local = "Local Street"
        case shared = "Shared Lanes"
        case painted = "Painted Lanes"
        case protected = "Protected Bike Lanes"
    }
}

extension Bikeway {
    static let jsonUrl = #fileLiteral(resourceName: "bikeways.geojson")
    
    static let loadFromUrl: (URL) throws -> [Bikeway] = 
    getDataFromContentsOfUrl
    >>> MKGeoJSONDecoder().decode
    >>> compactMap(makeSegment)
    >>> groupBy(\.category)
    >>> map(^\.value >>> Bikeway.init)
}

fileprivate let makeSegment = 
asType(MKGeoJSONFeature.self)
>>> twin
>>> first(getPolyline)
>>> second(getCategory)
>>> zip
>>> flatMap(Bikeway.Segment.build)

fileprivate let getPolyline = 
flatMap(^\MKGeoJSONFeature.geometry.first 
          >>> asType(MKPolyline.self))

fileprivate let getCategory = 
flatMap(^\MKGeoJSONFeature.properties) 
>>> flatMap(serializeJSON
            >>> getValuesOfType(String.self)
            >>> ^"bikeway_type"
            >>> flatMap(Bikeway.Category.init(rawValue:)))
