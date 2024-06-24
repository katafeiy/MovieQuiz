//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Константин Филиппов on 20.06.2024.
//

import Foundation

//protocol QuestionFactoryProtocol {
//    func requestNextQuestion() -> QuizQuestion?
//}

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    func setDelegate(_ delegate: QuestionFactoryDelegate)
        
}
