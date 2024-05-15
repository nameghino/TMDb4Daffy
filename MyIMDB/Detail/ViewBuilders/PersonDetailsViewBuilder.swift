//
//  PersonDetailsViewBuilder.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

class PersonDetailsViewBuilder: DetailsViewBuilder {

    var viewModel: PersonDetailsViewModel

    init(viewModel: PersonDetailsViewModel) {
        self.viewModel = viewModel
    }

    func buildCard() -> UIView {
        let label = UILabel()
        label.text = viewModel.person.name
        label.textColor = .red
        label.backgroundColor = .white
        label.sizeToFit()
        return label
    }

    var images: [ImageKey : Data] = [:]
}
