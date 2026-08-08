//
//  MemoryLeakTracker.swift
//  ViaCep
//
//  Created by Thiago Monteiro on 10/05/25.
//

import Testing

final class MemoryLeakTracker<T: AnyObject> {
    private weak var instance: T?
    private var sourceLocation: SourceLocation
    
    init(_ instance: T, sourceLocation: SourceLocation) {
        self.instance = instance
        self.sourceLocation = sourceLocation
    }
    
    deinit {
        #expect(
            instance == nil,
            """
            💥 Potential Memory Leak Detected!
            ⚠️ Instance of type '\(T.self)' was not deallocated.
            📍 Tracked from: \(sourceLocation.fileName) Line: \(sourceLocation.line)
            """,
            sourceLocation: sourceLocation
        )
    }
}

class MemoryLeakTrackingSuite {
    private var trackers = [AnyObject]()
    
    func trackForMemoryLeak<T: AnyObject>(_ instance: T, source: SourceLocation) {
        let tracker = MemoryLeakTracker(instance, sourceLocation: source)
        trackers.append(tracker)
    }
}
