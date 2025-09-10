//
//  IntExtension.swift
//  TodoList
//
//  Created by Денис Ефименков on 10.09.2025.
//

import Foundation

extension Int {
    var tasksWord: String {
        let remainder10 = self % 10
        let remainder100 = self % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "Задач"
        }
        
        switch remainder10 {
        case 1: return "Задача"
        case 2...4: return "Задачи"
        default: return "Задач"
        }
    }
}

