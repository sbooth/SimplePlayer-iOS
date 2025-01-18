//
// Copyright (c) 2011-2025 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/SimplePlayer-iOS
// MIT license
//

import SwiftUI
import Combine
import SFBAudioEngine

class PlayerViewModel: ObservableObject {
	let dataModel: DataModel

	private let displayLinkPublisher = DisplayLinkPublisher()
	private var cancellables = Set<AnyCancellable>()

	private lazy var playbackTimeSubject = PassthroughSubject<PlaybackTime, Never>()
	var playbackTime: AnyPublisher<PlaybackTime, Never> {
		playbackTimeSubject
			.eraseToAnyPublisher()
	}

	init(dataModel: DataModel) {
		self.dataModel = dataModel
		displayLinkPublisher
			.receive(on: DispatchQueue.main)
			.sink { _ in
				if let time = dataModel.player.time {
					self.playbackTimeSubject.send(time)
				}
			}
			.store(in: &cancellables)
	}

	deinit {
		cancellables.removeAll()
	}

	func seekBackward() {
		dataModel.player.seekBackward()
	}

	func seekForward() {
		dataModel.player.seekForward()
	}

	func togglePlayPause() {
		try? dataModel.player.togglePlayPause()
	}

	func seek(position: Double) {
		if let current = dataModel.player.position?.progress {
			let tolerance = 0.01
			if abs(current - position) >= tolerance {
				dataModel.player.seek(position: position)
			}
		}
	}
}
