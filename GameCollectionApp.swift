import SwiftUI

@main
struct GameCollectionApp: App {
    @StateObject private var gameData = GameData() //Shared state for the app

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameData) //Provides GameData as an EnvironmentObject
        }
    }
}
