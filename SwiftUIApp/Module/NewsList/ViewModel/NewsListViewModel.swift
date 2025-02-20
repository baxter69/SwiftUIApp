//
//  ViewModel.swift
//  SwiftUIApp
//
//  Created by user on 12.01.2025.
//

import SwiftUI

extension NewsListView {
    @Observable
    class ViewModel {
        private let networkManager = NetworkManager()
        var searchText: String = ""
        // устанавливать разрешено только внутри класса, просмотр разрешен везде
        private(set) var news: [News] = []
        
        func sendRequest() {
            guard !searchText.isEmpty else { return }
            networkManager.sendRequest(query: searchText) { result in
                switch result {
                case .success(let news):
                    self.news = news
                    self.setupSortedNewsByDate()
                case .failure:
                    self.news = []
                }
            }
        }
        
        func setupSortedNewsByDate() {
            news.sort { $0.getDate() ?? Date() > $1.getDate() ?? Date() }
        }
    }
}
