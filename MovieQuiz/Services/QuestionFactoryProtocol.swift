import Foundation

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    
    func loadData()
    
    func setDelegate(_ delegate: QuestionFactoryDelegate)
    
    var countElements: Int { get }
        
}
