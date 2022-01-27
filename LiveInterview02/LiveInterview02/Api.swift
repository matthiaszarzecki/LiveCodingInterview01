//
//  Api.swift
//  LiveInterview02
//
//  Created by Matthias Zarzecki on 26.01.22.
//

import Foundation

final class Api {
  func getFruits(
    completion: @escaping (Result<FruitResponse, NetworkError>) -> Void
  ) {
    let urlString = "https://gist.githubusercontent.com/gcbrueckmann/0484975ede56eeb7fba6e143aab7df0f/raw/edfb73c8ade674f40bfff8f3dfed97d327c1abc1/fruits.json"

    guard let url = URL(string: urlString) else {
      return DispatchQueue.main.async {
        completion(.failure(.badUrl))
      }
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
      if response.statusCode != 200 {
        DispatchQueue.main.async {
          completion(.failure(.badResponse))
        }
      } else {
        if let unwrappedData = data, let result = try? JSONDecoder().decode(
          FruitResponse.self,
          from: unwrappedData
        ) {
          if result.fruits.isEmpty {
            DispatchQueue.main.async {
              completion(.failure(.emptyData))
            }
          }

          completion(.success(result))
        } else {
          DispatchQueue.main.async {
            completion(.failure(.parsingFailed))
          }
        }
      }
    }.resume()
  }
}

struct FruitResponse: Codable {
  var fruits: [Fruit]
}

enum NetworkError: Error {
  case badUrl
  case parsingFailed
  case emptyData
  case badResponse
}

extension Optional where Wrapped == URLResponse {
  /// Returns the HTTP status code from an
  /// URLResponse-Optional. Returns nil on failure.
  var statusCode: Int? {
    if let httpResponse = self as? HTTPURLResponse {
      return httpResponse.statusCode
    }
    return nil
  }
}

struct Fruit: Codable {
  var name: String
  var imageUrl: String
  var weight: Double?
  var price: Int

  enum CodingKeys: String, CodingKey {
    case name
    case imageUrl = "image"
    case weight
    case price
  }
}
