//
//  DisplayLink.swift
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

import WolfCore

public class DisplayLink: Invalidatable {
    public typealias FiredBlock = (DisplayLink) -> Void
    public var firstTimestamp: CFTimeInterval!
    public var elapsedTime: CFTimeInterval { return timestamp - firstTimestamp }

    private var displayLink: CADisplayLink!
    private let onFired: FiredBlock

    public init(preferredFramesPerSecond: Int = 30, onFired: @escaping FiredBlock) {
        self.onFired = onFired
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        if #available(iOS 10.0, *) {
            displayLink.preferredFramesPerSecond = min(60, preferredFramesPerSecond)
        }
        displayLink.add(to: RunLoop.main, forMode: .common)
    }

    deinit {
        displayLink.invalidate()
    }

    @objc private func displayLinkFired(displayLink: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = timestamp
        }

//        if #available(iOS 10.0, *) {
//        print( 1.0 / (displayLink.targetTimestamp - displayLink.timestamp))
//        }

        onFired(self)
    }

    public func invalidate() { displayLink.invalidate() }

    public var timestamp: CFTimeInterval { return displayLink.timestamp }
    public var duration: CFTimeInterval { return displayLink.duration }

    @available(iOS 10.0, *)
    public var targetTimestamp: CFTimeInterval {
        return displayLink.targetTimestamp
    }

    public var isPaused: Bool {
        get { return displayLink.isPaused }
        set { displayLink.isPaused = newValue }
    }

    @available(iOS 10.0, *)
    public var preferredFramesPerSecond: Int {
        get { return displayLink.preferredFramesPerSecond }
        set { displayLink.preferredFramesPerSecond = newValue }
    }
}
