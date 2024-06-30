import Foundation

final class StatisticService: StatisticServiceProtocol {
    

    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
        case countCorrect
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            let currentGamesCount = UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
            let newGamesCount = currentGamesCount + 1
            storage.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correctOld = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let totalOld = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let dateOld = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correctOld, total: totalOld, date: dateOld)
        }
        set {
            
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
            
        }
    }
    
    var totalAccuracy: Double {
        
        get {
            
            storage.double(forKey: Keys.totalAccuracy.rawValue)
            
            if Double(gamesCount) != 0 {
                
                return (Double(countCorrect) / (10 * Double(gamesCount))) * 100.00
                
            } else {
                
                return 0
                
            }
        }
        set {
            
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
            
        }
    }
    
    var countCorrect: Int {
        
        get {
            storage.integer(forKey: Keys.countCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.countCorrect.rawValue)
        }
        
    }
    
    func saveResult(correct count: Int, total amount: Int) {
        
        let newBestGame = GameResult(correct: count, total: amount, date: Date())
        
        if bestGame.bestRecord(newBestGame) { bestGame = newBestGame }
        
        gamesCount += 1
        countCorrect += count

    }
}




