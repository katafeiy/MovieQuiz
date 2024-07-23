import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var pressButtonYes: UIButton!
    @IBOutlet private weak var pressButtonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewImage: UIImageView!
    
    private var presenter: MovieQuizPresenter!
    
    var alert: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = .init(viewController: self)
        
        let alert = AlertPresenter()
        
        alert.setDelegate(self)
        
        self.alert = alert
        
        setupFonts()
        setupUI()
        
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
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
        
        guard let questionFactory = presenter.questionFactory else { return }
        presenter.restartGame()
        questionFactory.requestNextQuestion()
        
        if questionFactory.countElements < 20 {
            questionFactory.loadData()
        }
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
    
    // функция вывода алерта
    
    func presentAlert(viewController: UIViewController) {
        
        present(viewController, animated: true, completion: nil)
        
    }
    
    // функция отображения индикатора загрузки
    
   func showLoadingIndicator() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    func hideLoadingIndicator() {
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    // функция блокировки кнопок
    
    func blockingButtonPresses(isEnable: Bool) {
        
        pressButtonYes.isEnabled = isEnable
        pressButtonNo.isEnabled = isEnable
        
    }
    
    // функция очистки UserDefault
    
    func reset() {
        
        let allValue = UserDefaults.standard.dictionaryRepresentation()
        
        allValue.forEach { UserDefaults.standard.removeObject(forKey: $0.key) }
        
    }
    
    // функция отображения ошибки при неудачной загрузки данных
    
    func showNetworkError(message: String) {
        
        hideLoadingIndicator()
        
        let errorMessage = AlertModel(title: "Ошибка!\n",
                                      message: message,
                                      buttonText: "Попробовать еще раз...") { [ weak self ] in
            
            guard let self = self else { return }
            
            presenter.questionFactory?.loadData()
            
        }
        
        alert?.show(quiz: errorMessage, isShowRestart: false)
    }
    
}

