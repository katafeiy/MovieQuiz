import Foundation

protocol AlertPresenterProtocol: AnyObject {
    
    var delegate: AlertPresenterDelegate? { get set }
    
    func show(quiz result: AlertModel, isShowRestart: Bool)
    
}

