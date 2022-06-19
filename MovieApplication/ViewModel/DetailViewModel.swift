//
//  DetailViewModel.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation

protocol DetailViewModelProtocol: AnyObject {
    func setData()
    func startIndicator()
    func stopIndicator()
    func showPopup()

}

class DetailViewModel {
    weak var delegate: DetailViewModelProtocol?

    
    private var manager: NetworkManager = NetworkManager()
    var movieDetail: MovieDetail?
    var mediaID: Int?
    
    func getMovieDetail() {
        self.delegate?.startIndicator()
        guard let mediaID = mediaID else { return }
        manager.getDetail(mediaID: String(mediaID), type: .detail) { [weak self] (response: NetworkResponse<MovieDetail, NetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.movieDetail = result
                self.delegate?.setData()
                self.delegate?.stopIndicator()
                break
            case .failure(let error):
                print(error.errorMessage)
                self.delegate?.stopIndicator()
                self.delegate?.showPopup()

            }
        }
    }
}
