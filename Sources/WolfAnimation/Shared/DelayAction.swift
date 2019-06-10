//
//  DelayAction.swift
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

/** Can be used to add a delay to a sequence */
public class DelayAction: FiniteTimeAction {

    // MARK: - Public

    /**
     Create with duration
     - Parameter duration: The duration of the deley
     */
    public init(duration: Double) {
        self.duration = duration
    }

    // MARK: - Properties

    public let duration: Double
    public var reverse = false

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    // MARK: - Methods

    public func willBecomeActive() {
        onBecomeActive?()
    }

    public func didBecomeInactive() {
        onBecomeInactive?()
    }

    public func willBegin() {
    }

    public func didFinish() {
    }

    public func update(t: CFTimeInterval) {
    }
}
