//
//  MoBikesApp.swift
//  MoBikes-Watch WatchKit Extension
//
//  Created by Andrew on 2021-02-28.
//

import SwiftUI
import MoBikes_WatchCore

@main
struct MoBikesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StationsView()
            }
        }
    }
}
