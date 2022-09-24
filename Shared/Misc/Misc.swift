import Foundation

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

extension Array where Element: Hashable {
    var asSet: Set<Element> { Set(self) }
}

func getUnique<A, B, ID: Hashable>(_ xs: [A], withID idA: (A) -> ID, 
                                   and ys: [B], withID idB: (B) -> ID) -> ([A], [B]) {
    let xIds = xs.map(idA).asSet
    let yIds = ys.map(idB).asSet
    let uniqueA = xs.filter { !yIds.contains(idA($0)) }
    let uniqueB = ys.filter { !xIds.contains(idB($0)) }
    return (uniqueA, uniqueB)
}

let getDataFromContentsOfUrl = flip(curry(Data.init(contentsOf:options:)))([])

let serializeJSON: (Data) -> [String: Any] = { data in
    if let json = try? JSONSerialization.jsonObject(with: data),
       let dict = json as? [String: Any] {
        return dict
    } else { 
        return [:] 
    }
}

func getValuesOfType<A>(_ a: A.Type) -> ([String: Any]) -> [String: A] {
    return { dict in
        dict.compactMapValues { $0 as? A }
    }
}

let separateAndTrimWhitespace = 
flip(String.components)(",")
>>> map(flip(String.trimmingCharacters)(.whitespaces))

// Tagged
// https://github.com/pointfreeco/swift-tagged
struct Tagged<Tag, RawValue> {
    let rawValue: RawValue
}

extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}
extension Tagged: Codable where RawValue: Codable {}
extension Tagged: Comparable where RawValue: Comparable {
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Tagged: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByStringLiteral {
    init(stringLiteral value: RawValue.StringLiteralType) {
        self.init(rawValue: RawValue(stringLiteral: value))
    }
    
    init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self.init(rawValue: RawValue(extendedGraphemeClusterLiteral: value))
    }
    
    init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self.init(rawValue: RawValue(unicodeScalarLiteral: value))
    }
}

extension String {
    func tagged<Tag>() -> Tagged<Tag, String> {
        .init(rawValue: self)
    }
}
