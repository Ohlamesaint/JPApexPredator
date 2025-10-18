//
//  JPApexPredatorsApp.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,

        didFinishLaunchingWithOptions _: [
            UIApplication.LaunchOptionsKey: Any
        ]? =
            nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct JPApexPredatorsApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
