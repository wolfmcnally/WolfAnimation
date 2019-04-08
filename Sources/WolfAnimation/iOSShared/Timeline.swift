//
//  Timeline.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 6/30/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import WolfLog
import WolfCore

extension LogGroup {
    public static let timeline = LogGroup("timeline")
}

public class Timeline {
    private var events = [Event]()
    private var notifyWorkItem: DispatchWorkItem?
    private var displayLink: DisplayLink?
    private var nextEventIndex: Int = 0

    public init() {
    }

    private class Event: Comparable, CustomStringConvertible {
        let time: TimeInterval
        let name: String
        private let action: Block
        var executeTime: TimeInterval?

        init(at time: TimeInterval, named name: String, action: @escaping Block) {
            self.time = time
            self.name = name
            self.action = action
        }

        public static func == (lhs: Event, rhs: Event) -> Bool { return lhs.time == rhs.time }
        public static func < (lhs: Event, rhs: Event) -> Bool { return lhs.time < rhs.time }

        public var description: String {
            return "\(name) (\(time %% 3))"
        }

        func execute(at executeTime: CFTimeInterval) {
            self.executeTime = executeTime
            logTrace("\(name) (\(executeTime %% 3) - \(time %% 3) = \((executeTime - time) %% 3))", group: .timeline)
            action()
        }
    }

    public func addEvent(at time: TimeInterval, named name: String, action: @escaping Block) {
        let event = Event(at: time, named: name, action: action)
        events.append(event)
    }

    private func finish() {
        displayLink?.invalidate()
    }

    private func executeCurrentEvents(elapsedTime: CFTimeInterval) {
        while true {
            guard nextEventIndex < events.count else { finish(); return }
            let event = events[nextEventIndex]
            if elapsedTime >= event.time {
                event.execute(at: elapsedTime)
                nextEventIndex += 1
                if nextEventIndex == events.count { finish(); break }
            } else {
                break
            }
        }
    }

    public func play() {
        events.sort(by: <)
        nextEventIndex = 0
        displayLink = DisplayLink { [unowned self] displayLink in
            self.executeCurrentEvents(elapsedTime: displayLink.elapsedTime)
        }
    }

    public func cancel() {
        finish()
    }
}
