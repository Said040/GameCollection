import SwiftUI

struct GameSectionView: View {
    let title: String
    let games: [Game]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding([.top, .leading, .trailing])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            VStack {
                                if let imageUrl = game.image?.screenURL, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Preview for GameSectionView
struct GameSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGames = [
            Game(id: 1, name: "Sample Game 1", deck: "Description 1", originalReleaseDate: "2024-12-27", platforms: [Platform(name: "PC")], image: GameImage(screenURL: "https://via.placeholder.com/150")),
            Game(id: 2, name: "Sample Game 2", deck: "Description 2", originalReleaseDate: "2024-12-27", platforms: [Platform(name: "PlayStation 5")], image: GameImage(screenURL: "https://via.placeholder.com/150")),
            Game(id: 3, name: "Sample Game 3", deck: "Description 3", originalReleaseDate: "2024-12-27", platforms: [Platform(name: "Xbox Series X")], image: GameImage(screenURL: "https://via.placeholder.com/150"))
        ]
        
        return NavigationStack {
            GameSectionView(title: "Sample Games", games: sampleGames)
                .environmentObject(GameData())
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
