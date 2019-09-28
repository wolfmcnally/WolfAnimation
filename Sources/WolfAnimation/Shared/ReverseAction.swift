//
//  ReverseAction.swift
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
import CoreFoundation

/** Reverses the inner action */
public class ReverseAction: FiniteTimeAction {

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    /**
     Create with the action to reverse
     - Parameter action: The action to reverse
     */
    init(action: FiniteTimeAction) {
        self.action = action
        self.action.reverse = true
    }

    // MARK: - Private Properties
    var action: FiniteTimeAction

    // MARK: - Private Methods

    public var reverse: Bool = false {
        didSet {
            action.reverse = !reverse
        }
    }

    public var duration: Double {
        return action.duration
    }

    public func willBecomeActive() {
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
        action.didFinish()
    }

    public func update(t: CFTimeInterval) {
        action.update(t: 1 - t)
    }
}

public extension FiniteTimeAction {
    func reversed() -> ReverseAction {
        return ReverseAction(action: self)
    }
}
