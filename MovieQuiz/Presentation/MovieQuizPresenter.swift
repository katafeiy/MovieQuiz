import UIKit

final class MovieQuizPresenter: UIViewController {
    
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol?
    weak var viewController: MovieQuizViewController?
    
    var correctAnswers = 0
    let questionAmount: Int = 10
    private var currentQuestionIndex = 0
    
    func isLastQuestion() -> Bool { currentQuestionIndex == questionAmount - 1 }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() { currentQuestionIndex += 1 }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer == true {
             self.correctAnswers += 1
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
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
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
    
    // функция завершения игры или вывода следующего вопроса
    
    func showNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
            statisticService = StatisticService()
            
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
