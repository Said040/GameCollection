import Foundation

//Game model
struct Game: Identifiable, Codable {
    let id: Int
    let name: String
    let deck: String?
    let originalReleaseDate: String?
    let platforms: [Platform]?
    let image: GameImage?
    var review: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case deck
        case originalReleaseDate = "original_release_date"
        case platforms
        case image
    }
}

//Model for platforms
struct Platform: Codable {
    let name: String
}

//Model for images
struct GameImage: Codable {
    let screenURL: String

    enum CodingKeys: String, CodingKey {
        case screenURL = "super_url"
    }
}

//API Response model to decode the response
struct APIResponse: Codable {
    let results: [Game]
}
class GameService {
    private let baseURL = "https://www.giantbomb.com/api/games/"
    private let apiKey = "12ca01233a1efb1af0bd07e81a1e60db0049fc40" //API key
    
    func searchGames(query: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlString = "https://www.giantbomb.com/api/games/?api_key=\(apiKey)&format=json&filter=name:\(query)&field_list=id,name,deck,original_release_date,platforms,image"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(.success(apiResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
