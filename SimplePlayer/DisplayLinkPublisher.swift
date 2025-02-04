//
// Copyright (c) 2020-2025 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/SimplePlayer-iOS
// MIT license
//

import Combine
import QuartzCore.CADisplayLink

/// A `Publisher` for `CADisplayLink` events
struct DisplayLinkPublisher: Publisher {
	/// The current absolute time in seconds
	static var currentTime: TimeInterval {
		return CACurrentMediaTime()
	}

	class Subscription<S>: Combine.Subscription where S: Subscriber, S.Failure == Never, S.Input == CFTimeInterval {
		private lazy var displayLink = CADisplayLink(target: self, selector: #selector(step))
		private let subscriber: AnySubscriber<CFTimeInterval, Never>

		private var demand: Subscribers.Demand = .unlimited {
			didSet {
				displayLink.isPaused = demand == .none
			}
		}

		fileprivate init(subscriber: S, preferredFramesPerSecond: Int) {
			self.subscriber = AnySubscriber(subscriber)
			displayLink.preferredFramesPerSecond = preferredFramesPerSecond
			displayLink.add(to: .main, forMode: .default)
		}

		deinit {
			displayLink.invalidate()
		}

		func request(_ demand: Subscribers.Demand) {
			self.demand = demand
		}

		func cancel() {
			demand = .none
		}

		@objc private func step(_ displayLink: CADisplayLink) {
			guard demand != .none else {
				return
			}
			demand -= 1
			demand += subscriber.receive(displayLink.targetTimestamp)
		}
	}

	public let preferredFramesPerSecond: Int

	public init(preferredFramesPerSecond: Int = 0) {
		self.preferredFramesPerSecond = preferredFramesPerSecond
	}

	public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Never, S.Input == CFTimeInterval {
		let subscription = Subscription(subscriber: subscriber, preferredFramesPerSecond: preferredFramesPerSecond)
		subscriber.receive(subscription: subscription)
	}

	public typealias Output = CFTimeInterval
	public typealias Failure = Never
}
