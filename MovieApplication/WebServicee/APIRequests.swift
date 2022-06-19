
import Foundation
import UIKit



struct NetworkManager {
    
    func getMedia<T: Decodable>(type: ListType, page: Int, completion: @escaping (NetworkResponse<T, NetworkError>) -> Void) {
        guard let endpoint = setEndPoint(type: type) else { return }
        
        let url = APIConstants.BASE_URL + endpoint + APIConstants.API_KEY + APIConstants.page + String(page)
        print("url:" ,url)
//        + APIConstants.LANGUAGE
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion(NetworkResponse.failure(.network))
                }
                if let safeData = data {
                    if let decodedData = try? JSONDecoder().decode(T.self, from: safeData) {
                        completion(NetworkResponse.success(decodedData))
                    } else {
                        completion(NetworkResponse.failure(.decoding))
                    }
                }
            }.resume()
        }
    }
    
    
    func getDetail<T: Decodable>(mediaID: String, type: ListType, completion: @escaping (NetworkResponse<T, NetworkError>) -> Void) {
        guard let endpoint = setEndPoint(type: type) else { return }
        let url = APIConstants.BASE_URL + endpoint + mediaID + "?" + APIConstants.API_KEY
        if let url = URL(string: url) {
            print("getDetail url:" ,url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion(NetworkResponse.failure(.network))
                }
                if let safeData = data {
                    if let decodedData = try? JSONDecoder().decode(T.self, from: safeData) {
                        completion(NetworkResponse.success(decodedData))
                    } else {
                        completion(NetworkResponse.failure(.decoding))
                    }
                }
            } .resume()
        }
    }
    
}

private func setEndPoint (type: ListType) -> String? {
    let endPoint: String?
    switch type {
    case .upComing:
        endPoint = "movie/upcoming?"
    case .nowPlaying:
        endPoint = "movie/now_playing?"
    case .detail:
        endPoint = "movie/"
    }
    return endPoint
}









