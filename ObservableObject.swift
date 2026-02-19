import SwiftUI

class GameData: ObservableObject {
    @Published var homeGames: [Game] = []
    @Published var myGames: [Game] = []
    @Published var wishlistedGames: [Game] = []
    @Published var inProgressGames: [Game] = []
    @Published var completedGames: [Game] = []
}
