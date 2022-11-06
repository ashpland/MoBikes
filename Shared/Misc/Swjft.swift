precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence, ComparisonPrecedence
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

func |> <A, B>(a: A, f: (A) throws -> B) throws -> B {
    return try f(a)
}

func |> <A, B>(a: A, f: (A) async throws -> B) async throws -> B {
    return try await f(a)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}

func >>> <A, B, C>(f: @escaping (A) throws -> B, g: @escaping (B) throws -> C) -> ((A) throws -> C) {
    return { a in
        try g(f(a))
    }
}

func >>> <A, B, C>(f: @escaping (A) async throws -> B, g: @escaping (B) async throws -> C) -> ((A) async throws -> C) {
    return { a in
        try await g(f(a))
    }
}

func identity<A>(_ value: A) -> A { value }

func asType<A>(_ type: A.Type) -> (Any) -> A? {
    return { $0 as? A }
}

func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: kp]
    }
}

prefix operator ^
prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return get(kp)
}

func get<Key: Hashable, Value>(_ key: Key) -> ([Key:Value]) -> Value? {
    return { $0[key] }
}

prefix func ^<Key: Hashable, Value>(_ key: Key) -> ([Key:Value]) -> Value? {
    get(key)
}

func assoc<Root, Value>(_ root: Root, _ kp: WritableKeyPath<Root, Value>, _ value: Value) -> Root {
    var root = root
    root[keyPath: kp] = value
    return root
}

func assoc<Root, Value>(_ kp: WritableKeyPath<Root, Value>, _ value: Value) -> (Root) -> Root {
    return { root in
        var root = root
        root[keyPath: kp] = value
        return root
    }
}

func update<Root, Value>(_ root: Root, _ kp: WritableKeyPath<Root, Value>, _ updatefn: (Value) -> Value) -> Root {
    let value = root[keyPath: kp]
    var root = root
    root[keyPath: kp] = updatefn(value)
    return root
}

func update<Root, Value>(_ kp: WritableKeyPath<Root, Value>, _ updatefn: @escaping (Value) -> Value) -> (Root) -> Root {
    return { root in
        let value = root[keyPath: kp]
        var root = root
        root[keyPath: kp] = updatefn(value)
        return root
    }
}

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { xs in xs.map(f) }
}

func map<A, B, C>(_ f: @escaping ((key: A, value: B)) -> C) -> ([A:B]) -> [C] {
    return { xs in xs.map(f) }
}

func flatMap<A, B>(_ f: @escaping (A) -> B?) -> (A?) -> B? {
    return { $0.flatMap(f) }
}

func flatMap<A, B>(_ f: @escaping (A) throws -> B?) -> (A?) throws -> B? {
    return { try $0.flatMap(f) }
}

func compactMap<A, B>(_ f: @escaping (A) -> B?) -> ([A]) -> [B] {
    return { $0.compactMap(f) }
}

func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(p) }
}

func groupBy<Key: Hashable, Value>(_ f: @escaping (Value) -> Key) -> ([Value]) -> [Key: [Value]] {
    return { Dictionary(grouping: $0, by: f) }
}

func groupBy<Key: Hashable, Value>(_ kp: KeyPath<Value, Key>) -> ([Value]) -> [Key: [Value]] {
    groupBy(^kp)
}

func firstTwo<A>(_ xs: [A]) -> (A, A)? {
    guard xs.count >= 2 else { return nil }
    return (xs[0], xs[1])
}

func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
    guard let a = a, let b = b else { return nil }
    return (a, b)
}

func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
    return { pair in
        return (f(pair.0), pair.1)
    }
}

func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
    return { pair in
        return (pair.0, f(pair.1))
    }
}

func second<A, B, C>(_ f: @escaping (B) throws -> C) -> ((A, B)) throws -> (A, C) {
    return { pair in
        return (pair.0, try f(pair.1))
    }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

func curry<A, B, C>(_ f: @escaping (A, B) throws -> C) -> (A) -> (B) throws -> C {
    return { a in { b in try f(a, b) } }
}

func curry<A, B, C>(_ f: @escaping (A, B) async throws -> C) -> (A) -> (B) async throws -> C {
    return { a in { b in try await f(a, b) } }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) throws -> C) -> (B) -> (A) throws -> C {
    return { b in { a in try f(a)(b) } }
}

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {
    return { { a in f(a)() } }
}

func flip<A, B>(_ f: @escaping (A) -> (B) -> Void) -> (B) -> (A) -> A {
    return { b in { a in 
        f(a)(b) 
        return a
    }}
}

func flip2ArgVoid<A, B, C>(_ f: @escaping (A) -> (B, C) -> Void) -> (C) -> (B) -> (A) -> A {
    return { c in { b in { a in
        f(a)(b, c)
        return a
    }}}
}

func zurry<A>(_ f: () -> A) -> A {
    return f()
}
