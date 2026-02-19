import SwiftUI

struct GameDetailView: View {
    let game: Game
    @EnvironmentObject var gameData: GameData
    @Environment(\.presentationMode) var presentationMode
    @State private var userReview: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //Game Image
                if let imageUrl = game.image?.screenURL, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    } placeholder: {
                        Color.gray
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }

                //Game Name
                Text(game.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                //Release Date
                if let releaseDate = game.originalReleaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.body)
                        .foregroundColor(.gray)
                }

                //Game Description
                if let deck = game.deck {
                    Text(deck)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                }

                //Platforms Section
                if let platforms = game.platforms, !platforms.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Platforms Available On:")
                            .font(.headline)
                            .padding(.top, -10)

                        ForEach(platforms, id: \.name) { platform in
                            Text(platform.name)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)
                }

                //Action Buttons
                VStack(spacing: 20) {
                    HStack(spacing: 10) {
                        Button("Add to Wishlist") {
                            addToCategory(&gameData.wishlistedGames)
                        }
                        .buttonStyle(CategoryButtonStyle(color: .blue))
                        
                        Button("In Progress") {
                            addToCategory(&gameData.inProgressGames)
                            addToCategory(&gameData.myGames)
                        }
                        .buttonStyle(CategoryButtonStyle(color: .orange))
                    }
                    HStack(spacing: 10) {
                        Button("Completed") {
                            addToCategory(&gameData.completedGames)
                            addToCategory(&gameData.myGames)
                        }
                        .buttonStyle(CategoryButtonStyle(color: .purple))
                        
                        Button("Remove") {
                            removeFromCategories()
                        }
                        .buttonStyle(CategoryButtonStyle(color: .red))
                    }
                }
                .padding(.vertical)
                
                //Review Section
                if gameData.completedGames.contains(where: { $0.id == game.id }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Write a Review")
                            .font(.headline)
                        
                        TextEditor(text: $userReview)
                            .frame(height: 100)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        
                        Button("Submit Review") {
                            submitReview()
                        }
                        .buttonStyle(CategoryButtonStyle(color: .green))
                        
                        if let existingReview = gameData.completedGames.first(where: { $0.id == game.id })?.review {
                            Text("Your Review:")
                                .font(.headline)
                                .padding(.top)
                            Text(existingReview)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical)
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }

    //Function that adds the game to a category
    private func addToCategory(_ category: inout [Game]) {
        if !category.contains(where: { $0.id == game.id }) {
            category.append(game)
            if !gameData.homeGames.contains(where: { $0.id == game.id }) {
                gameData.homeGames.append(game)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }

    //Function that removes the game from all instances
    private func removeFromCategories() {
        gameData.homeGames.removeAll { $0.id == game.id }
        gameData.wishlistedGames.removeAll { $0.id == game.id }
        gameData.myGames.removeAll { $0.id == game.id }
        gameData.inProgressGames.removeAll { $0.id == game.id }
        gameData.completedGames.removeAll { $0.id == game.id }
        presentationMode.wrappedValue.dismiss()
    }

    //Function that handles submitting the review to specific game
    private func submitReview() {
        if let index = gameData.completedGames.firstIndex(where: { $0.id == game.id }) {
            gameData.completedGames[index].review = userReview
        }
        userReview = "" //Resets the review text
    }
}


//Button Style for Category Buttons
struct CategoryButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

//Preview for GameDetailView
struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGame = Game(
            id: 1,
            name: "Sample Game",
            deck: "This is a sample game description.",
            originalReleaseDate: "2024-12-27",
            platforms: [Platform(name: "PC"), Platform(name: "PlayStation 5")],
            image: GameImage(screenURL: "https://via.placeholder.com/300")
        )

        GameDetailView(game: sampleGame)
            .environmentObject(GameData())
            .previewDevice("iPhone 13")
    }
}
