//
//  UIHelper.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import SnapKit

extension UIView {
    func pinToEdges(of superview: UIView, useSafeArea: Bool = true) {
        self.snp.makeConstraints { make in
            if useSafeArea {
                make.edges.equalTo(superview.safeAreaLayoutGuide)
            } else {
                make.edges.equalTo(superview)
            }
        }
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

enum Colors {
    static let backgroundGray = UIColor(r: 39, g: 39, b: 41)
    static let iconCheckMark = UIColor(r: 254, g: 215, b: 2)
    static let textColor = UIColor(r: 244, g: 244, b: 244)
    static let backgroundAppColor = UIColor(r: 4, g: 4, b: 4)
}

enum TextStyles {
    static let taskTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)

    static let taskDescriptionFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    static let taskDateFont = UIFont.systemFont(ofSize: 14, weight: .light)
}


