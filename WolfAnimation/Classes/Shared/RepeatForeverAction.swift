//
//  RepeatForeverAction.swift
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

/** Repeats inner action forever */
public class RepeatForeverAction: InfiniteTimeAction {

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    /**
     Create with an action to repeat forever
     - Parameter action: The action to repeat
     */
    public init(action: FiniteTimeAction) {
        self.action = action;
    }

    // MARK: - Private Properties
    let action: FiniteTimeAction
    var lastRepeatNumber = 0

    // MARK: - Private Methods

    public func willBecomeActive() {
        onBecomeActive?()
        action.willBecomeActive()
    }

    public func didBecomeInactive() {
        action.didBecomeInactive()
        onBecomeInactive?()
    }

    public func willBegin() {
        action.willBegin()
    }

    public func didFinish() {
        action.didFinish()
    }

    public func update(elapsedTime: CFTimeInterval) {

        let repeatNumber = Int(elapsedTime / action.duration)

        (lastRepeatNumber..<repeatNumber).forEach{ _ in
            self.action.didFinish()
            self.action.willBegin()
        }

        let actionT = (elapsedTime / action.duration).fractionalPart
        action.update(t: actionT)

        lastRepeatNumber = repeatNumber
    }
}

public extension FiniteTimeAction {
    func repeatedForever() -> RepeatForeverAction {
        return RepeatForeverAction(action: self)
    }
}
