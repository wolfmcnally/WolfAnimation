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
import WolfPipe
import WolfConcurrency

public protocol AnimatedHideable: Hideable {
    var alpha: CGFloat { get set }
}

extension AnimatedHideable {
    /// `hideWithFade` is useful for hiding views arranged by stack views. Hiding views
    /// within stack views inside an animation block triggers a "compressing" size animation.
    /// This makes it desirable to hide *and* fade at the same time.
    public func hide(animated: Bool, duration: TimeInterval? = nil, hideWithFade: Bool = false) {
        guard !isHidden else { return }
        let duration = duration ?? defaultAnimationDuration
        run <| animation(animated, duration: duration, options: [.beginFromCurrentState]) {
            if hideWithFade {
                self.hide()
            }
            self.alpha = 0
        } ||* {
            if !hideWithFade {
                self.hide()
            }
        }
    }

    public func show(animated: Bool, duration: TimeInterval? = nil) {
        guard isHidden else { return }
        let duration = duration ?? defaultAnimationDuration
        run <| animation(animated, duration: duration, options: [.beginFromCurrentState]) {
            self.show()
            self.alpha = 1
        }
    }

    public func showIf(_ condition: Bool, animated: Bool, duration: TimeInterval? = nil) {
        if condition {
            show(animated: animated, duration: duration)
        } else {
            hide(animated: animated, duration: duration)
        }
    }

    public func hideIf(_ condition: Bool, animated: Bool, duration: TimeInterval? = nil) {
        if condition {
            hide(animated: animated, duration: duration)
        } else {
            show(animated: animated, duration: duration)
        }
    }
}

public func hide<T: AnimatedHideable>(animated: Bool, duration: TimeInterval? = nil, hideWithFade: Bool = false) -> (_ t: T) -> T {
    return { t in
        t.hide(animated: animated, duration: duration, hideWithFade: hideWithFade)
        return t
    }
}
