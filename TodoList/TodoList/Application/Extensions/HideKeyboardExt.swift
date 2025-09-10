//
//  HideKeyboardExt.swift
//  TodoList
//
//  Created by Денис Ефименков on 10.09.2025.
//

import UIKit

extension UIViewController {
    func hideKeyboardWHentap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

