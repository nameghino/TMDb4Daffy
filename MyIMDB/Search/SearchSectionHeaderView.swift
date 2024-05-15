//
//  SearchSectionHeaderView.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

class SearchSectionHeaderView: UICollectionReusableView {

    static let ReuseIdentifier = "SearchSectionHeaderView"

    var title: String = "" {
        didSet {
            self.label.text = title
            self.label.sizeToFit()
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = self.title
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()

    private func setUp() {
        self.backgroundColor = .white
        self.addSubview(label)

        label.sizeToFit()

        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            self.label.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.label.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}
