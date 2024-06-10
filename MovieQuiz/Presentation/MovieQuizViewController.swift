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
    
    init(title: String, text: String, buttonText: String) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
    
}

// структура вопроса

struct QuizQuestion {
    
    let image: String
    let text: String
    let correctAnswer: Bool
    
}

private var currentQuestionIndex = 0
private var currentAnswers = 0

// имитация входящих данных (mock-данные)

let theGodfather = QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 9.1 ?", correctAnswer: true)
let theDarkKnight = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 8.7 ?", correctAnswer: true)
let killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 7.7 ?", correctAnswer: true)
let theAvengers =  QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 7.5 ?", correctAnswer: true)
let deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6.8 ?", correctAnswer: true)
let theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6.5 ?", correctAnswer: true)
let old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 5.9 ?", correctAnswer: false)
let theIceAgeAdventuresOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 5.6 ?", correctAnswer: false)
let tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 5.5 ?", correctAnswer: false)
let vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6.2 ?", correctAnswer: false)

// создания массива входящих данных

// Массив был создан именно в таком виде для наглядности, а также для тренировки написания кода, так как данный проект является учебным)))
// Можно было бы сократить код внося данные сразу в массив без создания переменных

private var question: [QuizQuestion] = [
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

private var currentQuestion = question[currentQuestionIndex]

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var pressButtonYes: UIButton!
    @IBOutlet private weak var pressButtonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupFonts()
        setupUI()
        randomSortArray()
        show(quiz: convert(model: currentQuestion))
        
    }
    
    @IBAction private func pressButtonYes(_ sender: UIButton) {
        
        let answer: Bool = true
        showAnswerResult(isCorrect: answer == question[currentQuestionIndex].correctAnswer)
        
    }
    
    @IBAction private func pressButtonNo(_ sender: UIButton) {
        
        let answer: Bool = false
        showAnswerResult(isCorrect: answer == question[currentQuestionIndex].correctAnswer)
        
    }
    
    // функция установки заданных шрифтов
    
    private func setupFonts() {
        
        pressButtonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        pressButtonYes.setTitleColor(.ypBlack, for: .normal)
        pressButtonYes.backgroundColor = .ypWhite
        pressButtonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        pressButtonNo.setTitleColor(.ypBlack, for: .normal)
        pressButtonNo.backgroundColor = .ypWhite
        questionsTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionsTitleLabel.textColor = .ypWhite
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.textColor = .ypWhite
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.textColor = .ypWhite
        
    }
    // функция установки заданных размеров, цветов и радиусов
    
    private func setupUI() {
        
        previewImage.layer.cornerRadius = 20
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = UIColor.clear.cgColor
        pressButtonYes.layer.cornerRadius = 15
        pressButtonYes.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        pressButtonYes.tintColor = .ypGreen
        pressButtonNo.layer.cornerRadius = 15
        pressButtonNo.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        pressButtonNo.tintColor = .ypRed
        
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
        
        blockingButtonPresses(isEnable: true)
        
    }
    
    // функция индикации правильного и не правильного ответа
    
    private func showAnswerResult(isCorrect: Bool) {
        
        blockingButtonPresses(isEnable: true)
        
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        blockingButtonPresses(isEnable: false)
        
        if isCorrect == true {
            currentAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.previewImage.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    // функция завершения игры или вывода следующего вопроса
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == question.count - 1 {
            
            let result = QuizResultsViewModel(title: "Раунд окончен!!!",
                                              text: currentAnswers == question.count ? "Отличный результат: \(currentAnswers)/ \(question.count)" : "Ваш результат: \(currentAnswers)/ \(question.count)",
                                              buttonText: currentAnswers == question.count ? "Хотите повторить?" : "Сыграть еще разок?")
            
            show(quiz: result)
            randomSortArray()
            
        } else {
            
            currentQuestionIndex += 1
            
            let nextQuestion = question[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
            
        }
    }
    
    // функция выбора повторной игры или выхода их приложения
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
            
            currentQuestionIndex = 0
            currentAnswers = 0
            
            show(quiz:convert(model:currentQuestion))
            
        }
        
        let cancel = UIAlertAction(title: "Выйти?", style: .default) { _ in
            
            exit(0)
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // функция блокировки кнопок
    
    private func blockingButtonPresses(isEnable: Bool) {
        
        pressButtonYes.isEnabled = isEnable
        pressButtonNo.isEnabled = isEnable
        
    }
    
    // функция сортировки массива случайным образом
    
    private func randomSortArray() {
        
        question = question.shuffled()
        currentQuestion = question[currentQuestionIndex]
        
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
