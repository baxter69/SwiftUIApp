//
//  File.swift
//  SwiftUIApp
//
//  Created by user on 19.02.2025.
//

import SwiftUI
import Combine

extension NewsDetailView {
    class ViewModel: ObservableObject {
        @Published var news: News
        @Published var image: UIImage? = nil
        
        private var cancellables = Set<AnyCancellable>()
        
        init(news: News) {
            self.news = news
            loadImage()
        }
        
        private func loadImage() {
            guard let url = news.getImageURL() else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.image, on: self)
                .store(in: &cancellables)
        }
    }
}
