//
//  InterpolateAction.swift
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

import WolfCore

/** Action to animate between two values */
public class InterpolationAction<T: Interpolable>: FiniteTimeAction {
    public typealias UpdateBlock = (T) -> ()
    public typealias DynamicValueBlock = () -> (T)

    private enum InterpolableValue {
        case constant(T)
        case dynamic(DynamicValueBlock)

        internal func getValue() -> T {
            switch self {
            case .constant(let value):
                return value
            case .dynamic(let closure):
                return closure()
            }
        }
    }

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?
    public var easing: Easing

    /**
     Create action to interpolate between two values
     - Parameter startValue: The value to animate from
     - Parameter endValue: The value to animate to
     - Parameter duration: The duration of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public init(from startValue: T,
                to endValue: T,
                duration: CFTimeInterval = defaultAnimationDuration,
                easing: Easing = .linear,
                update: UpdateBlock? = nil) {

        self.duration = duration
        self.updateHandler = update
        self.easing = easing

        self.startTweenableValue = .constant(startValue)
        self.endTweenableValue = .constant(endValue)
    }

    /**
     Create action to interpolate between two values
     - Parameter startValue: Closure that supplies the value to animation from (called just before the animation will begin)
     - Parameter endValue: The value to animate to
     - Parameter duration: The duration of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public init(from startValue: @escaping DynamicValueBlock,
                to endValue: T,
                duration: CFTimeInterval = defaultAnimationDuration,
                easing: Easing = .linear,
                update: UpdateBlock? = nil) {

        self.duration = duration
        self.updateHandler = update
        self.easing = easing

        self.startTweenableValue = .dynamic(startValue)
        self.endTweenableValue = .constant(endValue)
    }

    // MARK: - Properties

    public var reverse = false
    public var duration: CFTimeInterval

    private var startTweenableValue: InterpolableValue
    private var endTweenableValue: InterpolableValue

    private var startValue: T!
    private var endValue: T!

    var updateHandler: UpdateBlock?

    // MARK: - Methods

    public func willBecomeActive() {
        if startValue == nil {
            startValue = startTweenableValue.getValue()
        }

        if endValue == nil {
            endValue = endTweenableValue.getValue()
        }

        onBecomeActive?()
    }

    public func didBecomeInactive() {
        onBecomeInactive?()
    }

    public func willBegin() {
    }

    public func didFinish() {
        self.update(t: reverse ? 0.0 : 1.0)
    }

    public func update(t: Double) {
        // Apply easing
        var t = t
        t = easing.apply(t)

        // Calculate value
        let newValue = startValue.interpolated(to: endValue, at: t)

        // Call the update handler
        updateHandler?(newValue)
    }
}

extension InterpolationAction where T: Tweenable {
    /**
     Create action to interpolate between two values
     - Parameter startValue: The value to animate from
     - Parameter endValue: The value to animate to
     - Parameter speed: The speed of the animation
     - Parameter easing: The easing function to use
     - Parameter update: Callback with the interpolated value
     */
    public convenience init(from startValue: T,
                to endValue: T,
                speed: Double,
                easing: Easing = .linear,
                update: UpdateBlock? = nil) {

        var distance = startValue.distance(to: endValue)
        if distance < 0 {
            assert(true, "Distance returned from distance(to other:) in \(type(of: startValue)) must be positive.")
            distance = -distance
        }

        self.init(from: startValue, to: endValue, duration: distance / speed, easing: easing, update: update)
    }
}
