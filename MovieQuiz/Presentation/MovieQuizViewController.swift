import UIKit

// для состояния "Вопрос показан"

struct QuizStepViewModel {
    
    let image: UIImage
    let question: String
    let questionNumber: String
    
}

// для состояния "Результат квиза"

struct QuizResultsViewModel {
    
    let title: String
    let text: String
    let buttonText: String
    
}

// структура вопроса

struct QuizQuestion {
    
    let image: String
    let text: String
    let correctAnswer: Bool
    
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// имитация входящих данных (mock-данные)

let theGodfather = QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 9.1 ?", correctAnswer: true)
let theDarkKnight = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 8.7 ?", correctAnswer: true)
let killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 7 ?", correctAnswer: true)
let theAvengers =  QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 7.5 ?", correctAnswer: true)
let deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6.8 ?", correctAnswer: true)
let theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6.5 ?", correctAnswer: true)
let old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 5.9 ?", correctAnswer: false)
let theIceAgeAdventuresOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 5.6 ?", correctAnswer: false)
let tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 5.5 ?", correctAnswer: false)
let vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6.2 ?", correctAnswer: false)

// создания массива входящих данных

private let question: [QuizQuestion] = [
    theGodfather,
    theDarkKnight,
    killBill,
    theAvengers,
    deadpool,
    theGreenKnight,
    old,
    theIceAgeAdventuresOfBuckWild,
    tesla,
    vivarium
]
// Массив был создан именно в таком виде для наглядности, а также для тренировки написания кода, так данный проект является учебным)))
// Можно было бы сократить код внося данные сразу в массив без создания переменных
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

private var currentQuestionIndex = 0
private var currentAnswers = 0

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        setupUI()
        
        let currentQuestion = question[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction private func buttonYes(_ sender: UIButton) {
    }
    
    @IBAction private func buttonNo(_ sender: UIButton) {
    }
    
    // функция установки заданных шрифтов
    
    private func setupFonts() {
        
        buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionsTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
    }
    // функция установки заданных размеров и радиусов
    
    private func setupUI() {
        
        previewImage.layer.cornerRadius = 20
        buttonYes.layer.cornerRadius = 15
        buttonYes.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        buttonYes.tintColor = .ypGreen
        buttonNo.layer.cornerRadius = 15
        buttonNo.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        buttonNo.tintColor = .ypRed
        
    }
    
    // функция конвертации
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage.init(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(question.count)")
        return questionStep
    }
    
    // функция вывода на экран вопроса
    
    private func show(quiz step: QuizStepViewModel) {
        
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        previewImage.image = step.image
        
    }
    
}

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
