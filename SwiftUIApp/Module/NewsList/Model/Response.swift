//
//  Response.swift
//  SwiftUIApp
//
//  Created by Воротников Владимир on 12.01.2025.
//

import Foundation

struct Response: Decodable {
    let articles: [News]
}

//Подписал News под Identifiable, это  необходимо для того чтобы таблица увидела, что наш тип данных который мы ей скармливаем имеет уникальный id
struct News: Decodable, Identifiable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    // UUID позволит создать уникальное значение для объекта, получаем уникальное значение для использования в связки с List
    var id = UUID()
    
    private enum CodingKeys: CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt
    }
    
    func getImageURL() -> URL? {
        guard let urlString = urlToImage, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    func getURL() -> URL? {
        guard let urlString = url else {
            return nil
        }
        return URL(string: urlString)
    }
    
    func getDate() -> Date? {
        guard let dateString = publishedAt else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
    
    func getDisplayDate() -> String {
        guard let date = getDate() else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getAuthorSource() -> String {
        var result: String = ""
        if let author = author {
            result += "\(author)"
        }
        if let sourceName = source?.name {
            if !result.isEmpty {
                result += ", ®"
            }
            result += sourceName
        }
        return result
    }
}

struct Source: Decodable, Hashable {
    let id: String?
    let name: String?
}
