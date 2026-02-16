//
// SPDX-FileCopyrightText: 2011 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/SimplePlayer-iOS
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var model: DataModel

	var body: some View {
		return NavigationView {
			List(model.tracks) { track in
				NavigationLink(destination: PlayerView(viewModel: PlayerViewModel(dataModel: model))
					.onAppear(perform: {
						if let decoder = try? track.decoder() {
							try? model.player.play(decoder)
						}
					})
						.onDisappear(perform: { model.player.stop() })) {
							TrackView(track: track)
						}
			}
			.navigationBarTitle("Tracks")
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(DataModel())
}
