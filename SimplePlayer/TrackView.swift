//
// SPDX-FileCopyrightText: 2011 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/SimplePlayer-iOS
//

import SwiftUI

struct TrackView: View {
	let track: Track

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text(track.metadata.title ?? track.url.lastPathComponent)
				.font(.headline)
				.fontWeight(.bold)
			Text(track.metadata.artist ?? "")
				.font(.subheadline)
		}
	}
}

#Preview {
	TrackView(track: Track(url: URL(string: "Santeria.mp3")!))
}
