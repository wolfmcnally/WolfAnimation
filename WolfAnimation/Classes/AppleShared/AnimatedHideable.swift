//
//  AnimatedHideable.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 6/30/17.
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

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import WolfFoundation

public protocol AnimatedHideable: Hideable {
    var alpha: CGFloat { get set }
}

extension AnimatedHideable {
    public func hide(animated: Bool) {
        guard !isHidden else { return }
        dispatchAnimated(animated, options: [.beginFromCurrentState]) {
            self.alpha = 0
        }.then { _ in
            self.hide()
        }.run()
    }

    public func show(animated: Bool) {
        guard isHidden else { return }
        dispatchAnimated(animated, options: [.beginFromCurrentState]) {
            self.show()
            self.alpha = 1
        }.run()
    }

    public func showIf(_ condition: Bool, animated: Bool) {
        if condition {
            show(animated: animated)
        } else {
            hide(animated: animated)
        }
    }

    public func hideIf(_ condition: Bool, animated: Bool) {
        if condition {
            hide(animated: animated)
        } else {
            show(animated: animated)
        }
    }
}
