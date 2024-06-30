import Foundation

// структура для передачи результатов квиза и замыкания для перезапуска квиза

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> ()
    
    init(title: String, message: String, buttonText: String, completion: @escaping () -> Void) {
        
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.completion = completion
        
    }
}


