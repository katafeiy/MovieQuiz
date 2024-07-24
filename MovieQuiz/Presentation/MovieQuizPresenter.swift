import UIKit

final class MovieQuizPresenter: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private weak var viewController: MovieQuizViewController?
    
    private var correctAnswers = 0
    private let questionAmount: Int = 10
    private var currentQuestionIndex = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        
        super.init(nibName: nil, bundle: nil)
        self.viewController = viewController as? MovieQuizViewController
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        viewController.showLoadingIndicator()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    
    // функция отображения ошибки при неудачной загрузки картинки
    
    func errorFromDownloadImage(with error: Error) {
        
        viewController?.hideLoadingIndicator()
        
        let errorMessage = AlertModel(title: "Ошибка!\n",
                                      message: error.localizedDescription,
                                      buttonText: "Попробовать еще раз...") { [ weak self ] in
            
            guard let self = self else { return }
            
            self.questionFactory?.requestNextQuestion()
            
        }
        
        viewController?.alert?.show(quiz: errorMessage, isShowRestart: false)
    }

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer == true {
             correctAnswers += 1
        }
    }
    
    // функция конвертации
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return questionStep
        
    }
        
    func pressButtonYes() { didAnswer(isYes: true) }
    
    func pressButtonNo() { didAnswer(isYes: false) }
    
    private func didAnswer(isYes: Bool) {
        
        let answer = isYes
        guard let currentQuestion = currentQuestion else { return }
        proceedWithAnswer(isCorrect: answer == currentQuestion.correctAnswer)
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // функция индикации правильного и не правильного ответа
    
    func proceedWithAnswer(isCorrect: Bool) {
        
        viewController?.blockingButtonPresses(isEnable: true)
        
        viewController?.previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        viewController?.blockingButtonPresses(isEnable: false)
        
        didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
           
            
            proceedToNextQuestionOrResults()
            viewController?.previewImage.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    // функция завершения игры или вывода следующего вопроса
    
    func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
            guard let statisticService = statisticService, let viewController = viewController else { return }
            
            statisticService.saveResult(correct: correctAnswers, total: questionAmount)
            
            let result = correctAnswers  == questionAmount ? "Отличный результат" : "Ваш результат"
            let question = correctAnswers == questionAmount ? "Хотите повторить?" : "Сыграть еще разок?"
            
            let message = result + ": \(correctAnswers) из \(questionAmount)!\n" +
            "Количество завершенных квизов: \(statisticService.gamesCount)\n" +
            "Рекорд: \(statisticService.bestGame.correct) из \(statisticService.bestGame.total) [\(statisticService.bestGame.date.dateTimeString)]\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%\n" + "\n" + question
            
            
            let alertModel = AlertModel(title: "Раунд окончен!\n",
                                        message: message,
                                        buttonText: "Да",
                                        completion: viewController.completion)
            
            let isShowRestart = statisticService.gamesCount > 1
            
            viewController.alert?.show(quiz: alertModel, isShowRestart: isShowRestart)
            
        } else {
            
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            
        }
    }
}
