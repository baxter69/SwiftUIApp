//
//  UserSetting.swift
//  SwiftUIApp
//
//  Created by user on 17.02.2025.
//
import SwiftUI
import Combine


final class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("searchHistory", defaultValue: ["SwiftUI", "iOS", "Apple"])
    var searchHistory: [String] {
        willSet {
            objectWillChange.send()
        }
    }
}
