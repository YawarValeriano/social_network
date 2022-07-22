//
//  CategoriesEnum.swift
//  social_network
//
//  Created by admin on 7/18/22.
//

import Foundation

enum CategoryType: String, Codable, CaseIterable {
case Action,
    Comedy,
    Drama,
    Fantasy,
    Horror,
    Mystery,
    Romance,
    Thriller,
    Western,
    Other
}

extension CaseIterable where Self: Equatable {

    func elementIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }

}
