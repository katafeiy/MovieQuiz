import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var pressButtonYes: UIButton!
    @IBOutlet private weak var pressButtonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var presenter = MovieQuizPresenter()
    var alert: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenter.viewController = self
        
        let statisticService = StatisticService()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        let alert = AlertPresenter()
        
        alert.setDelegate(self)
        questionFactory.setDelegate(self)
        
        self.statisticService = statisticService
        self.questionFactory = questionFactory
        self.alert = alert
        
        setupFonts()
        setupUI()
        
        showLoadingIndicator()
        questionFactory.loadData()
        
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
        
        guard let questionFactory else { return }
        presenter.restartGame()
        questionFactory.requestNextQuestion()
        
        if questionFactory.countElements < 20 {
            questionFactory.loadData()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        presenter.didReceiveNextQuestion(question: question)
        
    }

    // MARK: - Actions
    
    @IBAction private func pressButtonYes(_ sender: UIButton) {
    
        presenter.pressButtonYes()
        
    }
    
    @IBAction private func pressButtonNo(_ sender: UIButton) {
        
        presenter.pressButtonNo()
        
    }
    
    // функция вывода на экран вопроса
    
    func show(quiz step: QuizStepViewModel) {
        
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        previewImage.image = step.image
        
        blockingButtonPresses(isEnable: true)
        
    }
    
    // функция индикации правильного и не правильного ответа
    
    func showAnswerResult(isCorrect: Bool) {
        
        blockingButtonPresses(isEnable: true)
        
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        blockingButtonPresses(isEnable: false)
        
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
           
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            previewImage.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    // функция вывода алерта
    
    func presentAlert(viewController: UIViewController) {
        
        present(viewController, animated: true, completion: nil)
        
    }
    
    // функция отображения индикатора загрузки
    
    private func showLoadingIndicator() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    private func hideLoadingIndicator() {
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    // функция блокировки кнопок
    
    private func blockingButtonPresses(isEnable: Bool) {
        
        pressButtonYes.isEnabled = isEnable
        pressButtonNo.isEnabled = isEnable
        
    }
    
    // функция очистки UserDefault
    
    func reset() {
        
        let allValue = UserDefaults.standard.dictionaryRepresentation()
        
        allValue.forEach { UserDefaults.standard.removeObject(forKey: $0.key) }
        
    }
    
    // функция отображения ошибки при неудачной загрузки данных
    
    private func showNetworkError(message: String) {
        
        hideLoadingIndicator()
        
        let errorMessage = AlertModel(title: "Ошибка!\n",
                                      message: message,
                                      buttonText: "Попробовать еще раз...") { [ weak self ] in
            
            guard let self = self else { return }
            
            presenter.restartGame()
            questionFactory?.loadData()
            
        }
        
        alert?.show(quiz: errorMessage, isShowRestart: false)
    }
    
    // функция сообщения об успешной загрузке данных
    
    func didLoadDataFromServer() {
        
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
        
    }
    
    // функция сообщения об ошибке загрузки данных
    
    func didFailToLoadData(with error: Error) {
        
        showNetworkError(message: error.localizedDescription)
                
    }
    
    // функция отображения ошибки при неудачной загрузки картинки
    
    func errorFromDownloadImage(with error: Error) {
        
        hideLoadingIndicator()
        
        let errorMessage = AlertModel(title: "Ошибка!\n",
                                      message: error.localizedDescription,
                                      buttonText: "Попробовать еще раз...") { [ weak self ] in
            
            guard let self = self else { return }
            
            self.questionFactory?.requestNextQuestion()
            
        }
        
        alert?.show(quiz: errorMessage, isShowRestart: false)
        
    }
    
}

