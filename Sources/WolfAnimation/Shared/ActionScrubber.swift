//
//  ActionScrubber.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 1/4/19.
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

//
// Based on TweenKit by Steve Barnegren: https://github.com/SteveBarnegren/TweenKit
//

/**
 Used to manually control an action's time.
 Init with an action, and scrub using one of the update methods.
 Only supports FiniteTimeActions (RepeatForever not supported)
 */
public class ActionScrubber {

    // MARK: - Public

    /** If false, scrubbing past the start of the animation is clamped */
    public var clampTValuesBelowZero = false

    /** If false, scrubbing past the end of the animation is clamped */
    public var clampTValuesAboveOne = false

    public init(action: FiniteTimeAction) {
        self.action = action
    }

    /**
     Scrub the contained action to a specified time
     - parameter t: t (0-1) to scrub to
     */
    public func update(t: Double) {

        // Start the action
        if !hasBegun {
            action.willBecomeActive()
            action.willBegin()
            hasBegun = true
        }

        // Set correct reverse state
        var reverse = false

        if let lastT = lastUpdateT {
            reverse = t < lastT
        }

        if action.reverse != reverse {
            action.reverse = reverse
        }

        // Constrain t
        var t = t
        if clampTValuesBelowZero {
            t = max(0, t)
        }
        if clampTValuesAboveOne {
            t = min(t, 1)
        }

        // Update
        action.update(t: t)

        // Save t
        lastUpdateT = t
    }

    /**
     Scrub the contained action to a specified time
     - parameter elapsedTime: The time to scrub to in seconds
     */
    public func update(elapsedTime: Double) {
        update(t: elapsedTime / action.duration)
    }

    // MARK: - Properties

    private var action: FiniteTimeAction
    private var hasBegun = false
    private var lastUpdateT: Double?

}
