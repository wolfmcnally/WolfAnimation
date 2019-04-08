//
//  ActionGroup.swift
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

/** Runs several actions in parallel */
public class ActionGroup: FiniteTimeAction, SchedulableAction {

    // MARK: - Public

    /**
     Create with a set of actions
     - Parameter actions: The actions the group should contain
     */
    public convenience init(actions: FiniteTimeAction...) {
        self.init(actions: actions)
    }

    /**
     Create with a set of actions
     - Parameter actions: Array of actions the group should contain
     */
    public init(actions: [FiniteTimeAction]) {
        actions.forEach{
            add(action: $0)
        }
    }

    /**
     Create with a set of actions, all run with an offset
     - Parameter actions: Array of actions the group should contain
     - Parameter offset: The time offset of each action from the previous
     */
    public init(staggered actions: [FiniteTimeAction], offset: Double) {

        for (index, action) in actions.enumerated() {

            if index == 0 {
                add(action: action)
            }
            else{
                let delay = DelayAction(duration: offset * Double(index))
                let sequence = ActionSequence(actions: delay, action)
                add(action: sequence)
            }

        }
    }

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    public var reverse = false {
        didSet {
            wrappedActions = wrappedActions.map{ wrapped in
                wrapped.action.reverse = reverse
                return wrapped
            }
        }
    }

    // MARK: - Private Properties

    public internal(set) var duration = Double(0)
    private var triggerActions = [TriggerAction]()
    private var wrappedActions = [GroupActionWrapper]()
    private var lastUpdateT = 0.0

    // MARK: - Private methods

    private func add(action: FiniteTimeAction) {

        let allActions = wrappedActions.map{ $0.action } + (triggerActions as [FiniteTimeAction])
        for existingAction in allActions {
            if existingAction === action {
                fatalError("You cannot the same action to a group multiple times!")
            }
        }

        if let trigger = action as? TriggerAction {
            triggerActions.append(trigger)
        }
        else{
            let wrappedAction = GroupActionWrapper(action: action)
            wrappedActions.append(wrappedAction)
            calculateDuration()
        }
    }


    private func calculateDuration() {
        duration = wrappedActions.reduce(0){ max($0, $1.action.duration) }
    }

    public func willBecomeActive() {
        onBecomeActive?()
    }

    public func didBecomeInactive() {
        onBecomeInactive?()
    }

    public func willBegin() {

        // Set the last elapsed time
        lastUpdateT = reverse ? 1.0 : 0.0

        // Invoke trigger actions
        if reverse == false {
            triggerActions.forEach{
                $0.trigger()
            }
        }

        // Set actions in progress
        if !self.reverse {
            wrappedActions.forEach{
                $0.state = .inProgress
            }
        }
    }

    public func didFinish() {

        // Finish actions
        for wrapper in wrappedActions {

            if wrapper.state == .notStarted {
                wrapper.state = .inProgress
            }

            if wrapper.state == .inProgress {
                wrapper.state = .finished
            }
        }

        // If we're being called in reverse, now we should call the trigger actions
        if reverse == true {
            triggerActions.forEach{
                $0.trigger()
            }
        }
    }

    public func update(t: CFTimeInterval) {

        let elapsedTime = t * duration
        let lastElapsedTime = lastUpdateT * duration

        for wrapper in wrappedActions {

            // Update the action if it is in progress
            if elapsedTime <= wrapper.action.duration {

                wrapper.state = .inProgress
                wrapper.action.update(t: elapsedTime / wrapper.action.duration)
            }

                // Finish the action?
            else if !reverse, lastElapsedTime < wrapper.action.duration, elapsedTime > wrapper.action.duration {
                wrapper.state = .finished
            }
        }

        lastUpdateT = t
    }

}

class GroupActionWrapper {

    enum State {
        case notStarted
        case inProgress
        case finished
    }

    init(action: FiniteTimeAction) {
        self.action = action
    }

    var action: FiniteTimeAction

    var state = State.notStarted {
        didSet{

            if state == oldValue {
                return
            }

            switch state {
            case .inProgress:
                action.willBecomeActive()
                action.willBegin()
            case .finished:
                action.didFinish()
                action.didBecomeInactive()
            case .notStarted: break
            }
        }
    }
}
