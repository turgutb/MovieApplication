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
    func setTableViewHeight()
    func setSlider()
}


class MainViewModel {
    weak var delegate: MainViewModelProtocol?
    private var manager: NetworkManager = NetworkManager()
    var isPagination: Bool? = false
    var counter = 0

    
    var upComingPage: Int = 1 {
        didSet {
            getUpComing(page: upComingPage)
        }
    }
    
    var nowPlayingPage: Int = 1 {
        didSet {
            getNowPlaying(page: nowPlayingPage)
        }
    }
    
    var upComingMovies: [MovieResult] = [] {
        didSet(oldArray) {
            print("upComingMovies.count", upComingMovies.count)
            print("upComingMovies oldArray", oldArray.count)
            if upComingMovies.count > oldArray.count {
                self.delegate?.reloadTableView()
            }
        }
    }

    var nowPlayingMovies: [MovieResult] = [] {
        didSet(oldArray) {
//            print("nowPlayingMovies.count", nowPlayingMovies.count)
//            print("nowPlayingMovies oldArray", oldArray.count)
            if nowPlayingMovies.count > oldArray.count {
                self.delegate?.reloadCollectionView()
            }
        }
    }
    
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
                self.upComingMovies = self.upComingMovies + data
                self.isPagination = false
                break
            case .failure(let error):
                print(error.errorMessage)
                self.isPagination = false
            }
        }
    }
    
    func getNowPlaying(page: Int) {
        print("getNowPlaying:", page)
        manager.getMedia(type: .nowPlaying, page: page) { [weak self] (response: NetworkResponse<Upcoming, NetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                guard let data = result.results else { return }
                self.nowPlayingMovies = self.nowPlayingMovies + data
                if self.nowPlayingMovies.count > 0 {
                    self.delegate?.setSlider()
                }
                self.isPagination = false
                break
            case .failure(let error):
                print(error.errorMessage)
                self.isPagination = false
            }
        }
    }
}
