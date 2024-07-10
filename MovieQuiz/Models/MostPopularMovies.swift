import UIKit

struct MostPopularMovies: Codable {
    
    let errorMessage: String?
    let items: [MostPopularMovie]?
    
}

struct MostPopularMovie: Codable {
    
    let title: String?
    let rating: String?
    let imageURL: URL?
        
    var resizedImageURL: URL? {
        
        guard let imageURL = imageURL,
              let urlComponents = URLComponents(url: imageURL, resolvingAgainstBaseURL: true),
              let url = urlComponents.url
        else { return imageURL }
        
        let lastPathComponent = url.lastPathComponent
        let array = lastPathComponent.components(separatedBy: "._")
        
        guard let first = array.first else { return imageURL }
       
        let newLastPathComponent = first + "._V0_UX600_.jpg"
        let newURL = url.deletingLastPathComponent()
        let path = newURL.appendingPathComponent(newLastPathComponent)
        return path
        
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
        
    }
    
}
