//
//  ActionScheduler.swift
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

public class ActionScheduler: Cancelable {
    public var isCanceled: Bool {
        return animations.isEmpty
    }

    public func cancel() {
        removeAll()
    }

    // MARK: - Public

    /**
     Run an action
     - Parameter action: The action to run
     - Returns: Animation instance. You may wish to keep this, so that you can remove the animation later using the remove(animation:) method
     */
    @discardableResult public func run(action: SchedulableAction) -> Animation {
        let animation = Animation(action: action)
        add(animation: animation)
        return animation
    }

    /**
     Adds an Animation to the scheduler. Usually you don't need to construct animations yourself, you can run the action directly.
     - Parameter animation: The animation to run
     */
    public func add(animation: Animation) {
        animations.append(animation)
        animation.willStart()
        startLoop()
    }

    /**
     Removes a currently running animation
     - Parameter animation: The animation to remove
     */
    public func remove(animation: Animation) {

        guard let index = animations.index(of: animation) else {
            print("Can't find animation to remove")
            return
        }

        animation.didFinish()
        animations.remove(at: index)

        if animations.isEmpty {
            stopLoop()
        }
    }

    /**
     Removes all animations
     */
    public func removeAll() {

        let allAnimations = animations
        allAnimations.forEach{
            self.remove(animation: $0)
        }
    }

    /**
     The number of animations that are currently running
     */
    public var numRunningAnimations: Int {
        return self.animations.count
    }

    // MARK: - Properties

    private var animations = [Animation]()
    private var animationsToRemove = [Animation]()

    private var displayLink: DisplayLink?
    private var lastTimeStamp: CFTimeInterval?

    // MARK: - Deinit

    deinit {
        stopLoop()
    }

    // MARK: - Manage Loop

    private func startLoop() {

        if displayLink != nil {
            return
        }

        lastTimeStamp = nil

        displayLink = DisplayLink { [unowned self] displayLink in
            self.displayLinkCallback(displayLink)
        }
    }

    private func stopLoop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func displayLinkCallback(_ displaylink: DisplayLink) {

        // We need a previous time stamp to check against. Save if we don't already have one
        guard let last = lastTimeStamp else {
            lastTimeStamp = displaylink.timestamp
            return
        }

        // Update Animations
        let dt = displaylink.timestamp - last
        step(dt: dt)

        // Save the current time
        lastTimeStamp = displaylink.timestamp
    }

    func step(dt: Double) {

        for animation in animations {
            if animation.hasDuration {
                // Animations containing finite time actions

                var remove = false
                if animation.elapsedTime + dt > animation.duration {
                    remove = true
                }

                let newTime = min(animation.elapsedTime + dt, animation.duration)
                animation.update(elapsedTime: newTime)

                if remove {
                    animationsToRemove.append(animation)
                }
            } else {
                // Animations containing infinite time actions

                let newTime = animation.elapsedTime + dt
                animation.update(elapsedTime: newTime)
            }
        }

        // Remove finished animations
        animationsToRemove.forEach{
            remove(animation: $0)
        }
        animationsToRemove.removeAll()

    }
}
