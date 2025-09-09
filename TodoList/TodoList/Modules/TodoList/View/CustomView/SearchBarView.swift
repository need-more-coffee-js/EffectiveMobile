//
//  SearchBar.swift
//  TodoList
//
//  Created by Денис Ефименков on 09.09.2025.
//

import UIKit
import SnapKit

final class TodoSearchBarView: UIView, UISearchBarDelegate {

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Поиск задач..."
        sb.searchBarStyle = .minimal
        return sb
    }()

    var onTextChanged: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(searchBar)
        searchBar.delegate = self

        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChanged?(searchText)
    }
}
