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
    static let footerBackground = UIColor(r: 39, g: 39, b: 41)
}


