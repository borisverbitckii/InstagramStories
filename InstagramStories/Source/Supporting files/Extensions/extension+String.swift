//
//  extension+String.swift
//  InstagramStories
//
//  Created by Борис on 08.12.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
