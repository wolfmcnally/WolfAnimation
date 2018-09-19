//
//  FrameBasedSimulator.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 Wolf McNally.
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

//open class FrameBasedSimulator {
//    public weak var system: FrameBasedSystem?
//
//    public init(system: FrameBasedSystem? = nil) {
//        self.system = system
//    }
//
//    private var myTime: TimeInterval!
//
//    public func start() {
//        myTime = nil
//    }
//
//    public func update(deltaTime: TimeInterval) {
//        if myTime == nil {
//            myTime = 0
//        }
//
//        update(to: myTime + deltaTime)
//    }
//
//    public func update(to currentTime: TimeInterval) {
//        guard let system = system else { return }
//
//        if myTime == nil {
//            myTime = currentTime
//        }
//
//        let elapsedTime = currentTime - myTime
//
//        var remainingTime = elapsedTime
//        while remainingTime > 0 && myTime < currentTime {
//            let actualDuration = system.update(deltaTime: remainingTime)
//            assert(actualDuration <= remainingTime)
//            remainingTime -= actualDuration
//            myTime = myTime + actualDuration
//        }
//    }
//}

//open class FrameBasedSimulator {
//    public weak var system: FrameBasedSystem?
//
//    public init(system: FrameBasedSystem? = nil) {
//        self.system = system
//    }
//
//    private var myTime: TimeInterval!
//
//    public func start() {
//        myTime = nil
//        _ = system?.transition()
//    }
//
//    public func update(deltaTime: TimeInterval) {
//        if myTime == nil {
//            myTime = 0
//        }
//
//        update(to: myTime + deltaTime)
//    }
//
//    public func update(to currentTime: TimeInterval) {
//        guard let system = system else { return }
////        guard !isPaused else { return }
//
//        if myTime == nil {
//            myTime = currentTime
//        }
//
//        let elapsedTime = currentTime - myTime
//
//        var remainingTime = elapsedTime
//        while remainingTime > 0 && myTime < currentTime {
//            let (actualDuration, timeBeforeTransition) = system.simulate(forUpTo: remainingTime)
//            assert(actualDuration > 0 || timeBeforeTransition <= 0)
//            if timeBeforeTransition <= 0 {
//                system.transition()
//            }
//            remainingTime -= actualDuration
//            myTime = myTime + actualDuration
//        }
//    }
//
//    public func invalidate() {
//        system = nil
//    }
//}
