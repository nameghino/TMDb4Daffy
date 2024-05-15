//
//  DetailsViewController.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {

    var viewBuilder: DetailsViewBuilder

    private lazy var cardView: UIView = { self.viewBuilder.buildCard() }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()

    init(viewBuilder: DetailsViewBuilder) {
        self.viewBuilder = viewBuilder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.translatesAutoresizingMaskIntoConstraints = false


        self.scrollView.addSubview(self.cardView)
        self.view.addSubview(self.scrollView)


        let frameGuide = self.scrollView.frameLayoutGuide
        let contentGuide = self.scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            frameGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            frameGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.cardView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.cardView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.cardView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -10.0),
        ])

    }
}
