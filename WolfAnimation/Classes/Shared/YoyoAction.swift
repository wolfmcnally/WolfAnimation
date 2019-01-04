//
//  YoyoAction.swift
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

import WolfConcurrency

/** Animates inner action to end and then back to beginning */
public class YoyoAction: FiniteTimeAction {

    // MARK: - Types

    enum State {
        case idle
        case forwards
        case backwards
    }

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    public var reverse = false {
        didSet{
            if reverse != oldValue, state != .idle {
                action.reverse = !action.reverse
            }
        }
    }

    /**
     Create with action to yoyo
     - Parameter action: The action to yoyo
     */
    public init(action: FiniteTimeAction) {

        self.action = action
        self.duration = action.duration * 2
    }

    // MARK: - Private Properties

    public internal(set) var duration: Double
    var action: FiniteTimeAction
    var state = State.idle

    // MARK: - Private Methods

    public func willBecomeActive() {
        onBecomeActive?()
        action.willBecomeActive()
    }

    public func didBecomeInactive() {
        onBecomeInactive?()
        action.didBecomeInactive()
    }

    public func willBegin() {
        self.update(t: reverse ? 1.0 : 0.0)
    }

    public func didFinish() {

        self.update(t: reverse ? 0.0 : 1.0)
        action.didFinish()
        state = .idle
    }

    public func update(t: CFTimeInterval) {

        /*
         The order of state changes and setReverse is important here. The inner action should receive the following calls:

         - will begin
         - will finish
         - reverse = true
         - will begin
         - will finish

         The inner action is 'invoked twice' (two begin/finish calls), and it has the correct reverse state at the time of each call
         There are unit tests that test the call order, please run them after making changes
         */

        if t < 0.5 {

            if state == .idle {
                action.reverse = reverse
                action.willBegin()
            }

            if state == .backwards {
                action.didFinish()
                action.reverse = reverse
                action.willBegin()
            }

            let actionT = t * 2
            action.update(t: actionT)

            state = .forwards
        }
        else{

            if state == .idle {
                action.reverse = !reverse
                action.willBegin()
            }

            if state == .forwards {
                action.didFinish()
                action.reverse = !reverse
                action.willBegin()
            }

            let actionT = 1-((t - 0.5) * 2);
            action.update(t: actionT)

            state = .backwards
        }
    }
}

public extension FiniteTimeAction {

    public func yoyo() -> YoyoAction {
        return YoyoAction(action: self)
    }
}
