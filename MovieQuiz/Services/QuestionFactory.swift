import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    var countElements: Int { return movies.count }
    
    
    private var moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        
        self.moviesLoader = moviesLoader
        self.delegate = delegate
        
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        
        moviesLoader.loadMovies { [ weak self ] result in
            
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let mostPopularMovies):
                    
                    self.movies = mostPopularMovies.items ?? []
                    self.delegate?.didLoadDataFromServer()
                    
                case .failure(let error):
                    
                    self.delegate?.didFailToLoadData(with: error)
                    
                }
                
            }
            
        }
        
    }
    
    func setDelegate(_ delegate: QuestionFactoryDelegate) {
        
        self.delegate = delegate
        
    }
    
    func requestNextQuestion() {
        
        let index = (0..<self.movies.count).randomElement() ?? 0
        
        guard var movie = self.movies[safe: index] else { return }
        
        
        func resultData(image: Data) {
            
            let rating = Float(movie.rating ?? "") ?? 0
            
            let element = Float.random(in: 4.5...9.9)
            
            let randomRating = Float(String(format: "%.1f", element)) ?? 0
            
            let text = "Рейтинг этого фильма больше чем \(randomRating)?"
            
            let correctAnswer = rating > randomRating
            
            let question = QuizQuestion(image: image,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [ weak self ] in
                
                guard let self = self else { return }
                
                self.delegate?.didReceiveNextQuestion(question: question)
                
                movie = movies.remove(at: index)
                
            }
        }
        
        guard let url = movie.resizedImageURL else { return }
        
        let request = URLRequest(url: url, timeoutInterval: 1)
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            
            if let error = error {
                
                DispatchQueue.main.async {
                    
                    self.delegate?.errorFromDownloadImage(with: error)
                }
                return
            }
            
            if let data = data {
                
                resultData(image: data)
                
                return
            }
            
            DispatchQueue.main.async {
                
                resultData(image: Data())
                
            }
            
        }
        
        task.resume()        
    }
    
}

// имитация входящих данных (mock-данные)

//    private var questions: [QuizQuestion]
//
//    init() {
//
//        let theGodfather = QuizQuestion(image: "The Godfather",
//                                        text: "Рейтинг этого фильма больше чем 9.1 ?",
//                                        correctAnswer: true)
//        let theDarkKnight = QuizQuestion(image: "The Dark Knight",
//                                         text: "Рейтинг этого фильма больше чем 8.7 ?",
//                                         correctAnswer: true)
//        let killBill = QuizQuestion(image: "Kill Bill",
//                                    text: "Рейтинг этого фильма больше чем 7.7 ?",
//                                    correctAnswer: true)
//        let theAvengers =  QuizQuestion(image: "The Avengers",
//                                        text: "Рейтинг этого фильма больше чем 7.5 ?",
//                                        correctAnswer: true)
//        let deadpool = QuizQuestion(image: "Deadpool",
//                                    text: "Рейтинг этого фильма больше чем 6.8 ?",
//                                    correctAnswer: true)
//        let theGreenKnight = QuizQuestion(image: "The Green Knight",
//                                          text: "Рейтинг этого фильма больше чем 6.5 ?",
//                                          correctAnswer: true)
//        let theOld = QuizQuestion(image: "Old",
//                                  text: "Рейтинг этого фильма больше чем 5.9 ?",
//                                  correctAnswer: false)
//        let theIceAgeAdventuresOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                                                         text: "Рейтинг этого фильма больше чем 5.6 ?",
//                                                         correctAnswer: false)
//        let tesla = QuizQuestion(image: "Tesla",
//                                 text: "Рейтинг этого фильма больше чем 5.5 ?",
//                                 correctAnswer: false)
//        let vivarium = QuizQuestion(image: "Vivarium",
//                                    text: "Рейтинг этого фильма больше чем 6.2 ?",
//                                    correctAnswer: false)
//
//
//        questions = [
//            theGodfather,
//            theDarkKnight,
//            killBill,
//            theAvengers,
//            deadpool,
//            theGreenKnight,
//            theOld,
//            theIceAgeAdventuresOfBuckWild,
//            tesla,
//            vivarium
//        ]
//
//        // Массив был создан именно в таком виде для наглядности, а также для тренировки написания кода, так как данный проект является учебным)))
//        // Можно было бы сократить код внося данные сразу в массив без создания переменных
//    }

//func requestNextQuestion() {
//
//    guard let index = (0..<questions.count).randomElement() else {
//
//        delegate?.didReceiveNextQuestion(question: nil)
//
//        return
//    }
//
//    var question = questions[safe: index]
//
//    delegate?.didReceiveNextQuestion(question: question)
//
//    question = questions.remove(at: index)
//
//    return
//}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

