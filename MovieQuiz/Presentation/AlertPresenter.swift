import UIKit

// функция выбора повторной игры или выхода их приложения

class AlertPresenter: AlertPresenterProtocol {
    
    private var resetAllValue = MovieQuizViewController()
    weak var delegate: AlertPresenterDelegate?
    
    func setDelegate(_ delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func show(quiz result: AlertModel) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            
            guard let _ = self else { return }
            
            result.completion()
            
        }
        
        let reset = UIAlertAction(title: "Сбросить резальтаты?", style: .default) { _ in
            
            self.resetAllValue.reset()
            
        }
        
        let cancel = UIAlertAction(title: "Выйти?", style: .default) { _ in
            
            exit(0)
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addAction(reset)
        
        delegate?.presentAlert(viewController: alert)
        
    }
    
}
