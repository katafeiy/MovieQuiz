import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var pressButtonYes: UIButton!
    @IBOutlet private weak var pressButtonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    private var currentAnswers = 0
    private var currentQuestionIndex = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactory = QuestionFactory.init()
    private var currentQuestion: QuizQuestion?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        setupUI()
        setupQuestions()
    }
    
    @IBAction private func pressButtonYes(_ sender: UIButton) {
        
        let answer: Bool = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func pressButtonNo(_ sender: UIButton) {
        
        let answer: Bool = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
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
    
    // функция создания вопроса
    
    private func setupQuestions() {
        
        guard let question = questionFactory.requestNextQuestion() else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    // функция конвертации
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage.init(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            showNextQuestionOrResults()
            previewImage.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    // функция завершения игры или вывода следующего вопроса
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionAmount - 1 {
            
            let result = QuizResultsViewModel(title: "Раунд окончен!!!",
                                              text: currentAnswers == questionAmount ? "Отличный результат, вы ответели на \(currentAnswers) из \(questionAmount)!" : "Ваш результат: \(currentAnswers) из \(questionAmount), попробуйте еще раз!",
                                              buttonText: currentAnswers == questionAmount ? "Хотите повторить?" : "Сыграть еще разок?")
            
            show(quiz: result)
            
        } else {
            
            currentQuestionIndex += 1
            setupQuestions()
        }
    }
    
    // функция выбора повторной игры или выхода их приложения
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            currentQuestionIndex = 0
            currentAnswers = 0
           
            questionFactory = QuestionFactory()
            
            setupQuestions()
            
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
    
}

