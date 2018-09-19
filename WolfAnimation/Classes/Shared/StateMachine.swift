//
//  StateMachine.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 11/13/17.
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

import Foundation

open class StateMachine {
    open class State {
        public internal(set) weak var stateMachine: StateMachine!

        public let validNextStates: [State.Type]

        public init(validNextStates: [State.Type]) {
            self.validNextStates = validNextStates
        }

        public func isValidNextState<C: State>(_ stateClass: C.Type) -> Bool {
            return validNextStates.contains { $0 == stateClass }
        }

        open func didEnter(from previousState: State?) { }

        // Returns the actual amount of time simulated, which must be in 0 ... deltaTime.
        open func update(deltaTime: TimeInterval) -> TimeInterval {
            return deltaTime
        }

        open func willExit(to nextState: State) { }
    }

    private let states: [State]
    public private(set) var currentState: State?
    public private(set) var currentTime: TimeInterval!

    public init(states: [State]) {
        self.states = states
        self.states.forEach { $0.stateMachine = self }
    }

    public func canEnterState<C: State>(_ stateClass: C.Type) -> Bool {
        guard let currentState = currentState else { return true }
        return currentState.isValidNextState(stateClass)
    }

    public func state<C: State>(forClass stateClass: C.Type) -> State? {
        return states.first { type(of: $0) == stateClass }
    }

    public enum Error: Swift.Error {
        case cannotEnterState(State.Type)
        case stateDoesNotExist(State.Type)
    }

    public func enter(_ stateClass: State.Type) throws {
        guard canEnterState(stateClass) else { throw Error.cannotEnterState(stateClass) }
        guard let nextState = state(forClass: stateClass) else {
            throw Error.stateDoesNotExist(stateClass)
        }
        let previousState = currentState
        previousState?.willExit(to: nextState)
        currentState = nextState
        nextState.didEnter(from: previousState)
    }

    public func update(deltaTime: TimeInterval) {
        if currentTime == nil { currentTime = 0 }
        update(to: currentTime + deltaTime)
    }

    public func update(to newCurrentTime: TimeInterval) {
        if currentTime == nil { currentTime = newCurrentTime }

        let elapsedTime = newCurrentTime - currentTime

        var remainingTime = elapsedTime
        while remainingTime > 0 && currentTime < newCurrentTime {
            guard let currentState = currentState else {
                currentTime = currentTime! + remainingTime
                remainingTime = 0
                return
            }
            let actualDuration = currentState.update(deltaTime: remainingTime)
            assert(actualDuration <= remainingTime)
            remainingTime -= actualDuration
            currentTime = currentTime! + actualDuration
        }
    }
}
