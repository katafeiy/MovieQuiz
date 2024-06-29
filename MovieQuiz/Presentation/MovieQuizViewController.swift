import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
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
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alert: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let statisticService = StatisticService()
        
        let questionFactory = QuestionFactory()
        let alert = AlertPresenter()
        
        alert.setDelegate(self)
        questionFactory.setDelegate(self)
        
        self.statisticService = statisticService
        self.questionFactory = questionFactory
        self.alert = alert
        
        setupFonts()
        setupUI()
        questionFactory.requestNextQuestion()
        
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
    
    // MARK: - AlertPresenter
    
    func completion() -> () {
        
        currentQuestionIndex = 0
        currentAnswers = 0
        
        questionFactory = QuestionFactory()
        questionFactory?.setDelegate(self)
        
        questionFactory?.requestNextQuestion()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    
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
    
    // MARK: - Private function
    
    
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
            
            guard let statisticService = statisticService else { return }
            
            statisticService.saveResult(correct: currentAnswers, total: questionAmount)
            
            let result = currentAnswers  == questionAmount ? "Отличный результат" : "Ваш результат"
            
            let message = result + ": \(currentAnswers) из \(questionAmount)!\n" +
            "Количество завершенных квизов: \(statisticService.gamesCount)\n" +
            "Рекорд: \(statisticService.bestGame.correct) из \(statisticService.bestGame.total) [\(statisticService.bestGame.date.dateTimeString)]\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%\n"
            
            let alertModel = AlertModel(title: "Раунд окончен!!!",
                                        
                                        message: message,
                                        
                                        buttonText: currentAnswers == questionAmount ? "Хотите повторить?" : "Сыграть еще разок?",
                                        
                                        completion: completion)
            
            let isShowRestart = statisticService.gamesCount > 1
            
            alert?.show(quiz: alertModel, isShowRestart: isShowRestart)
            
        } else {
            
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            
        }
    }
    
    // функция вывода алерта
    
    func presentAlert(viewController: UIViewController) {
        
        present(viewController, animated: true, completion: nil)
        
    }
    
    // функция блокировки кнопок
    
    private func blockingButtonPresses(isEnable: Bool) {
        
        pressButtonYes.isEnabled = isEnable
        pressButtonNo.isEnabled = isEnable
        
    }
    
    // функция очистки UserDefault
    
    func reset() {
        
        let allValue = UserDefaults.standard.dictionaryRepresentation()
        
        for (key, _) in allValue {
            UserDefaults.standard.removeObject(forKey: key)
            
        }
        
    }
    
}

