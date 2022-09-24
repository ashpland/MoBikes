//
//  MoBikesApp.swift
//  Shared
//
//  Created by Andrew on 2022-09-23.
//

import SwiftUI

@main
struct MoBikesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(StateManager.shared)
        }
    }
}
