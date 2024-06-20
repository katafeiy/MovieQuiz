//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Константин Филиппов on 20.06.2024.
//

import Foundation

// для состояния "Результат квиза"

struct QuizResultsViewModel {
    
    let title: String
    let text: String
    let buttonText: String
    
    init(title: String, text: String, buttonText: String) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
    
}
