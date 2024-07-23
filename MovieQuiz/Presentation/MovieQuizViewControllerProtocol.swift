import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    
}

