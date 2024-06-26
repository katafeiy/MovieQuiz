import Foundation

protocol StatisticServiceProtocol {
    
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func saveResult(correct count: Int, total amount: Int)
    
}

