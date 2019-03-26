//
//  RepeatAction.swift
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

import WolfNumerics
import WolfConcurrency

/** Repeats an inner action a specified number of times */
public class RepeatAction: FiniteTimeAction {

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    /**
     Create with an action to repeat
     - Parameter action: The action to repeat
     - Parameter times: The number of repeats
     */
    public init(action: FiniteTimeAction, times: Int) {
        self.action = action
        self.repeats = times
        self.duration = action.duration * Double(times)
    }

    // MARK: - Private Properties
    public var reverse: Bool = false {
        didSet{
            action.reverse = reverse
        }
    }

    public internal(set) var duration: Double
    var action: FiniteTimeAction
    let repeats: Int
    var lastRepeatNumber = 0

    // MARK: - Private Methods

    public func willBecomeActive() {
        lastRepeatNumber = 0
        action.willBecomeActive()
        onBecomeActive?()
    }

    public func didBecomeInactive() {

        action.didBecomeInactive()
        onBecomeInactive?()
    }

    public func willBegin() {
        action.willBegin()
    }

    public func didFinish() {

        // We might have skipped over the action, so we still need to run the full cycle
        (lastRepeatNumber..<repeats-1).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }

        action.didFinish()
    }

    public func update(t: CFTimeInterval) {

        let repeatNumber = max(Int( t * Double(repeats) ), repeats - 1)

        (lastRepeatNumber..<repeatNumber).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }

        let actionT = ( t * Double(repeats) ).fractionalPart

        // Avoid situation where fract is 0.0 because t is 1.0
        if t > 0 && actionT == 0  {
            action.update(t: 1.0)
        }
        else{
            action.update(t: actionT)
        }

        lastRepeatNumber = repeatNumber
    }

}

public extension FiniteTimeAction {
    func repeated(_ times: Int) -> RepeatAction {
        return RepeatAction(action: self, times: times)
    }
}
