import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameData: GameData
    @State private var searchText: String = ""
    @State private var games: [Game] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    let gameService = GameService()

    var body: some View {
        NavigationStack {
            ZStack {
                //Gradient background
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20.0) {
                    //Search bar
                    HStack {
                        TextField("Search...", text: $searchText, onCommit: searchGames)
                            .padding()
                            .frame(width: 300.0)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .purple, radius: 6, x: 0, y: 2)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                games = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 40.0)

                    //Shows the search results list if searchText is not empty
                    if !searchText.isEmpty {
                        if isLoading {
                            ProgressView().padding()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red).padding()
                        } else {
                            List(games) { game in
                                NavigationLink(destination: GameDetailView(game: game)
                                    .onDisappear {
                                        //Resets search state when navigating back
                                        resetSearch()
                                    }
                                ) {
                                    HStack {
                                        if let imageUrl = game.image?.screenURL, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image.resizable().scaledToFit().frame(width: 50, height: 50).cornerRadius(4)
                                            } placeholder: {
                                                Color.gray.frame(width: 50, height: 50).cornerRadius(4)
                                            }
                                        }
                                        Text(game.name)
                                    }
                                }
                            }
                        }
                    }

                    //Shows the game categories (Your Games, Wishlist, etc) only when not searching
                    if searchText.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                if !gameData.myGames.isEmpty {
                                    GameSectionView(title: "Your Games", games: gameData.myGames)
                                }

                                if !gameData.wishlistedGames.isEmpty {
                                    GameSectionView(title: "Wishlist", games: gameData.wishlistedGames)
                                }

                                if !gameData.inProgressGames.isEmpty {
                                    GameSectionView(title: "In Progress", games: gameData.inProgressGames)
                                }

                                if !gameData.completedGames.isEmpty {
                                    GameSectionView(title: "Completed", games: gameData.completedGames)
                                }
                            }
                            .padding(.bottom, 20.0)
                        }
                    }
                }
            }
            .navigationTitle("Game Search")
        }
    }

    private func searchGames() {
        guard !searchText.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        gameService.searchGames(query: searchText) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let games):
                    self.games = games
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func resetSearch() {
        searchText = ""
        games = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameData())
    }
}
