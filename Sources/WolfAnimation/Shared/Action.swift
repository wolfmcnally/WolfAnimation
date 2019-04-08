//
//  Action.swift
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

// MARK: - Schedulable Action

/** Protcol for any action that can be added to an ActionScheduler instance */
public protocol SchedulableAction : class {

    /** Called when the action bhecomes active */
    var onBecomeActive: Block? { get set }

    /** Called when the action becomes inactive */
    var onBecomeInactive: Block? { get set }

    func willBecomeActive()
    func didBecomeInactive()

    func willBegin()
    func didFinish()
}

// MARK: - Finite Time Action

/** Protocol for Actions that have a finite duration */
public protocol FiniteTimeAction : SchedulableAction {

    var duration: Double { get }
    var reverse: Bool { get set }
    func update(t: CFTimeInterval)
}

// MARK: - Trigger Action

/** Protocol for actions that trigger an event and have no duration */
public protocol TriggerAction: FiniteTimeAction {
    func trigger()
}

extension TriggerAction {
    var duration: Double {
        return 0
    }
}

// MARK: - Infinite Time Action

/** Protocol for actions that run indefinitely */
public protocol InfiniteTimeAction : SchedulableAction {
    func update(elapsedTime: CFTimeInterval)
}
