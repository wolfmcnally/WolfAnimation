//
//  DisplayLink-macOS.swift
//  WolfAnimation
//
//  Created by Wolf McNally on 4/3/18.
//

#if os(macOS)
import AppKit
import WolfCore

private func timerCallback(timer: CVDisplayLink, currentTime: UnsafePointer<CVTimeStamp>, outputTime: UnsafePointer<CVTimeStamp>, _: CVOptionFlags, _: UnsafeMutablePointer<CVOptionFlags>, sourceUnsafeRaw: UnsafeMutableRawPointer?) -> CVReturn {
    // Un-opaque the source
    guard let sourceUnsafeRaw = sourceUnsafeRaw else { return kCVReturnError }
    // Update the value of the source, thus, triggering a handle call on the timer
    let sourceUnmanaged = Unmanaged<DispatchSourceUserDataAdd>.fromOpaque(sourceUnsafeRaw)
    sourceUnmanaged.takeUnretainedValue().add(data: 1)

//    print(1.0 / CVDisplayLinkGetActualOutputVideoRefreshPeriod(timer))

    return kCVReturnSuccess
}

public class DisplayLink: Invalidatable {
    public typealias FiredBlock = (DisplayLink) -> Void

    private let timer: CVDisplayLink
    private let source: DispatchSourceUserDataAdd

    public var running: Bool { return CVDisplayLinkIsRunning(timer) }

    private let onFired: FiredBlock
    private let preferredFramesPerSecond: Int
    private var timeUntilNextFire: Double

    /**
     Creates a new DisplayLink that gets executed on the given queue

     - Parameters:
     - queue: Queue which will receive the callback calls
     */
    public init(on queue: DispatchQueue = DispatchQueue.main, preferredFramesPerSecond: Int = 30, onFired: @escaping FiredBlock) {
        self.preferredFramesPerSecond = min(60, preferredFramesPerSecond)
        self.onFired = onFired
        timeUntilNextFire = 1 / Double(preferredFramesPerSecond)

        // Source
        source = DispatchSource.makeUserDataAddSource(queue: queue)

        // Timer
        var timerRef: CVDisplayLink? = nil

        // Create timer
        var successLink = CVDisplayLinkCreateWithActiveCGDisplays(&timerRef)

        guard let timer = timerRef else {
            fatalError("Failed to create timer with active display")
        }

        // Set Output
        successLink = CVDisplayLinkSetOutputCallback(timer, timerCallback, Unmanaged.passUnretained(source).toOpaque())

        guard successLink == kCVReturnSuccess else {
            fatalError("Failed to create timer with active display")
        }

        // Connect to display
        successLink = CVDisplayLinkSetCurrentCGDisplay(timer, CGMainDisplayID())

        guard successLink == kCVReturnSuccess else {
            fatalError("Failed to connect to display")
        }

        self.timer = timer

        // Timer setup
        source.setEventHandler() { [weak self] in
            guard let slf = self else { return }
            slf.timeUntilNextFire -= CVDisplayLinkGetActualOutputVideoRefreshPeriod(slf.timer)
            while(slf.timeUntilNextFire < 0) {
                slf.timeUntilNextFire += 1 / Double(slf.preferredFramesPerSecond)
                slf.onFired(slf)
            }
        }

        start()
    }

    /// Starts the timer
    func start() {
        guard !running else { return }

        CVDisplayLinkStart(timer)
        source.resume()
    }

    /// Cancels the timer, can be restarted aftewards
    func cancel() {
        guard running else { return }

        CVDisplayLinkStop(timer)
        source.cancel()
    }

    public func invalidate() {
        if running {
            cancel()
        }
    }

    deinit {
        invalidate()
    }
}
#endif
