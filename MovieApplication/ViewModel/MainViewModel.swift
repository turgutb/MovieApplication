//
//  MainViewModel.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func reloadTableView()
    func reloadCollectionView()
    func setSlider()
    func showPopup()
}


class MainViewModel {
    weak var delegate: MainViewModelProtocol?
    private var manager: NetworkManager = NetworkManager()
    var isPagination: Bool? = false
    var counter = 0
    var upComingPage: Int = 1
    var nowPlayingPage: Int = 1
    var upComingMovies: [MovieResult] = []
    var nowPlayingMovies: [MovieResult] = []
    
    func upComingNumberOfRow() -> Int {
        return upComingMovies.count
    }
    func upComingCellForRow(at index: Int) -> MovieResult {
        return upComingMovies[index]
    }
    func nowPlayingNumberOfRow() -> Int {
        return nowPlayingMovies.count
    }
    func nowPlayingCellForRow(at index: Int) -> MovieResult {
        return nowPlayingMovies[index]
    }
    
    func getUpComing(page: Int) {
        manager.getMedia(type: .upComing, page: page) { [weak self] (response: NetworkResponse<NowPlaying, NetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let data = result.results else { return }
                if data.count > 0 {
                    self.upComingMovies = self.upComingMovies + data
                    self.delegate?.reloadTableView()
                    self.isPagination = true
                    self.upComingPage += 1
                }
                break
            case .failure(let error):
                print(error.errorMessage)
                self.delegate?.showPopup()
            }
        }
    }
    
    func getNowPlaying(page: Int) {
        manager.getMedia(type: .nowPlaying, page: page) { [weak self] (response: NetworkResponse<Upcoming, NetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let data = result.results else { return }
                if data.count > 0 {
                    self.nowPlayingMovies = self.nowPlayingMovies + data
                    self.delegate?.setSlider()
                }
                break
            case .failure(let error):
                print(error.errorMessage)
                self.delegate?.showPopup()

            }
        }
    }
}
