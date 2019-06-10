//
//  RunBlockAction.swift
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

/** Runs a block. Can be used to add callbacks in sequences */
public class RunBlockAction: TriggerAction {

    // MARK: - Public

    public var onBecomeActive: Block?
    public var onBecomeInactive: Block?

    /**
     Create with a callback closure
     - Parameter handler: The closure to call
     */
    public init(handler: @escaping Block) {
        self.handler = handler
    }

    // MARK: - Private

    let handler: Block
    public let duration = 0.0
    public var reverse: Bool = false

    public func trigger() {
        handler()
    }

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
        // Do nothing
    }
}
