import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var questions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonYes.layer.cornerRadius = 15
        buttonYes.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        buttonYes.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonYes.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        buttonYes.tintColor = .ypGreen
        buttonNo.layer.cornerRadius = 15
        buttonNo.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        buttonNo.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonNo.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        buttonNo.tintColor = .ypRed
        
        questions.font = UIFont(name: "YS Display-Medium", size: 20)

    }
    
    @IBAction func buttonYes(_ sender: Any) {
    }
    
    @IBAction func buttonNo(_ sender: Any) {
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
