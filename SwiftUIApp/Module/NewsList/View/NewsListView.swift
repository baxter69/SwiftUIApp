//
//  NewsListView.swift
//  SwiftUIApp
//
//  Created by Воротников Владимир on 12.01.2025.
//

import SwiftUI

struct NewsListView: View {
    @State var vm = ViewModel()
    var settings = UserSettings()
    
    var body: some View {
        NavigationStack {
            //инициализатор принимает только данные(news), вместо List(vm.news, id: \.self) благодаря тому что мы подписались на Identifiable
            List(vm.news) { oneNews in
                // выделим все ячейку в отдельную view
                NewsCell(news: oneNews)
                    .listRowBackground(Color.mint)
                    .listRowSeparatorTint(.white)
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText, placement: .toolbar, prompt: Text("Введите ключевое слово")) {
                ForEach(settings.searchHistory, id: \.self) { suggestion in
                    Text(suggestion)
                        .searchCompletion(suggestion)
                }
            }
            
            .navigationTitle("Новости")
            .navigationBarTitleDisplayMode(.inline)
            
            .onSubmit(of: .search) {
                vm.sendRequest()
                settings.searchHistory = getUpdatesSearchHistory(searchHistory: settings.searchHistory, addText: vm.searchText)
            }
            .toolbarBackground(Color.mint, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.teal.opacity(0.3)
                    .ignoresSafeArea()
            }
        }
    }
    
    private func getUpdatesSearchHistory(searchHistory: [String], addText: String) -> [String] {
        var searchHistory = searchHistory
        if let index = searchHistory.firstIndex(of: addText) {
            let element = searchHistory.remove(at: index)
            searchHistory.insert(element, at: 0)
        } else {
            searchHistory.insert(addText, at: 0)
        }
        return searchHistory
    }
}

#Preview {
    NewsListView()
}

struct NewsCell: View {
    var news: News
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(news: news)) {
            VStack (alignment: .leading, spacing: 10) {
                Text(news.getAuthorSource())
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                Text(news.title ?? "")
                    .font(.headline)
                Text(news.description ?? "")
                Text(news.getDisplayDate())
                    .font(.footnote)
                    .foregroundStyle(.brown)
            }
        }
    }
}
