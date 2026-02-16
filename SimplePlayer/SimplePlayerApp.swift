//
// SPDX-FileCopyrightText: 2011 Stephen F. Booth <contact@sbooth.dev>
// SPDX-License-Identifier: MIT
//
// Part of https://github.com/sbooth/SimplePlayer-iOS
//

import SwiftUI

@main
struct SimplePlayerApp: App {
	@StateObject private var model = DataModel()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(model)
				.onAppear {
					model.load()
				}
		}
	}
}
