//
// Copyright (c) 2011-2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/SimplePlayer-iOS
// MIT license
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
