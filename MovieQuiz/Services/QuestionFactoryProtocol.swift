import Foundation

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    
    func setDelegate(_ delegate: QuestionFactoryDelegate)
        
}
