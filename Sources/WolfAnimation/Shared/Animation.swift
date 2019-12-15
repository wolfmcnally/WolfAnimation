//
//  Animation.swift
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

import CoreFoundation
import WolfConcurrency

/**
 Actions added to the ActionScheduler are wrapped in an Animation Instance.
 You may wish to keep an Animation instance (it's returned when actions are run), so that you can stop the animation later.
 */
public class Animation : Equatable {

    // MARK: - Public

    /**
     Create an animation with the supplied action
     - Parameter action: The action to create the animation with
     */
    public init(action: SchedulableAction) {
        self.action = action
    }

    /**
     Closure to be called after each update
     */
    public var onDidUpdate: Block?

    // MARK: - Properties

    var hasDuration: Bool {
        return action is FiniteTimeAction
    }

    var duration: Double {

        guard let ftAction = action as? FiniteTimeAction else {
            return 0
        }

        return ftAction.duration
    }

    var elapsedTime: CFTimeInterval = 0

    private let action: SchedulableAction!

    // MARK: - Methods

    func willStart() {
        action.willBecomeActive()
        action.willBegin()
    }

    func didFinish() {
        action.didFinish()
        action.didBecomeInactive()
    }

    func update(elapsedTime: CFTimeInterval) {

        self.elapsedTime = elapsedTime

        if let action = action as? FiniteTimeAction {
            action.update(t: elapsedTime / duration)
        }
        else if let action = action as? InfiniteTimeAction {
            action.update(elapsedTime: elapsedTime)
        }

        onDidUpdate?()
    }
}

// MARK: - Equatable
public func ==(rhs: Animation, lhs: Animation) -> Bool {
    return rhs === lhs
}
