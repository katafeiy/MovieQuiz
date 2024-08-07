import UIKit

// функция выбора повторной игры или выхода их приложения

final class AlertPresenter: AlertPresenterProtocol {
    
    private var resetAllValue: MovieQuizViewController? = {
        let storiboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storiboard.instantiateViewController(withIdentifier: "MovieQuizViewController") as? MovieQuizViewController
        return vc
    }()
    
    weak var delegate: AlertPresenterDelegate?
    
    func setDelegate(_ delegate: AlertPresenterDelegate) {
        
        self.delegate = delegate
        
    }
    
    func show(quiz result: AlertModel, isShowRestart: Bool) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "quizAlert"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            
            guard let _ = self else { return }
            
            result.completion()
            
        }
        
        let cancel = UIAlertAction(title: "Выйти", style: .cancel) { _ in
            
            exit(0)
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        if isShowRestart {
            
            let reset = UIAlertAction(title: "Сбросить сессию", style: .destructive) { _ in
                
                self.resetAllValue?.reset()
                
                let statisticReset = AlertModel(title: "Сессия сброшена!" + "\n",
                                                message: "Хотите начать заново?",
                                                buttonText: "Да",
                                                completion: result.completion)
                
                self.show(quiz: statisticReset, isShowRestart: false)
                
            }
            
            alert.addAction(reset)
        }
        
        delegate?.presentAlert(viewController: alert)
    }
}
