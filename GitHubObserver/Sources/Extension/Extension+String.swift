//
//  Extension+String.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

