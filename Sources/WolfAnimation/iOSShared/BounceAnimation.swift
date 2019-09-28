//
//  BounceAnimation.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 2/5/17.
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

#if canImport(UIKit)
import UIKit
import WolfCore

public class BounceAnimation {
    private unowned let view: UIView
    private var isReleased = false

    public init(view: UIView) {
        self.view = view
    }

    public func animateDown() {
        isReleased = false
        _ = animation(duration: 0.1, options: [.beginFromCurrentState, .curveEaseOut]) {
            self.view.transform = .init(scaleX: 0.7, y: 0.7)
        }
    }

    public func animateUp() {
        guard !isReleased else { return }
        _ = animation(duration: 0.1, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.view.transform = .identity
        }
    }

    private var completion: Block?

    public func animateRelease(completion: Block? = nil) {
        isReleased = true
        self.completion = completion
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 40.0, options: [.allowUserInteraction], animations: {
            self.view.transform = .identity
        }, completion: { _ in
        }
        )

        dispatchOnMain(afterDelay: 0.25) {
            self.completion?()
        }
    }

    public func animateHighlight(oldHighlighted: Bool, newHighlighted: Bool) {
        guard oldHighlighted != newHighlighted else { return }
        if newHighlighted == true {
            animateDown()
        } else if newHighlighted == false {
            animateUp()
        }
    }

    public func animateSelect(oldSelected: Bool, newSelected: Bool) {
        guard oldSelected != newSelected else { return }
        if newSelected == true {
            animateRelease()
        }
    }
}
#endif
