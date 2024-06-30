import Foundation

struct GameResult  {
    
    var correct: Int // количество правильных ответов
    var total: Int // количество вопросов квиза
    let date: Date // дата завершения раунда
    
    func bestRecord(_ record: GameResult) -> Bool {
        correct < record.correct
    }
}
