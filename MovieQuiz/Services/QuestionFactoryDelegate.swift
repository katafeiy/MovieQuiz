//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Константин Филиппов on 21.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    
}
