//
//  NetworkManager.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/11.
//

import Foundation

final class NetworkManager {
    
    // MARK: - Method
    
    static let shared = NetworkManager()
    
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - GET
    
    func fetchMusicData(searchTerm: String = "Maroon", completion: @escaping NetworkCompletion) {
        guard let url = URL(string: "\(APIEnvironment.baseURL)term=\(searchTerm)&\(APIEnvironment.media)") else {
            return
        }
        
        performRequest(with: url) { result in
            completion(result)
        }
    }
    
    
    private func performRequest(with url: URL, completion: @escaping NetworkCompletion) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // URLRequest로 데이터 통신 -> httpMethod를 설정한 방식으로 통신

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let safeData = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                return
            }

            if let parsedJSON = self.parseJSON(of: safeData) {
                completion(.success(parsedJSON))
            } else {
                completion(.failure(.parseError))
            }
        }.resume()
    }

    
    private func parseJSON(of data: Data) -> [Music]? {
        do {
            let decoder = JSONDecoder()
            let musicData = try decoder.decode(MusicData.self, from: data)

            return musicData.results
        } catch {
            print(error)
            return nil
        }
    }
}
