import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var questionsTitleLabel: UILabel!
    @IBOutlet private weak var IndexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        setupUI()
        
    }
    
    @IBAction private func buttonYes(_ sender: Any) {
    }
    
    @IBAction private func buttonNo(_ sender: Any) {
    }
    
    private func setupFonts() {
        
        buttonYes.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        buttonNo.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionsTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        IndexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)

    }
    private func setupUI() {
        
        buttonYes.layer.cornerRadius = 15
        buttonYes.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        buttonYes.tintColor = .ypGreen
        buttonNo.layer.cornerRadius = 15
        buttonNo.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        buttonNo.tintColor = .ypRed
        previewImage.layer.cornerRadius = 20
        
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
