//
//  DetailViewController.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imdbImageView: UIImageView!

    
    // MARK: - Properties
    let viewModel = DetailViewModel()

    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getData()
        viewModel.delegate = self
    }
    
    
    
    
    // MARK: - Actions
    
    
    
    // MARK: - Functions
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = false
        setImage()

    }
    private func getData() {
        viewModel.getMovieDetail()
    }
    private func setImage() {
        let imdbGesture = UITapGestureRecognizer(target: self, action: #selector(openIMDB))
        imdbImageView.addGestureRecognizer(imdbGesture)
    }
    @objc func openIMDB(){
        if let data = viewModel.movieDetail {
            if let url = URL(string: APIConstants.IMDB_URL + data.imdbID) {
                UIApplication.shared.open(url)
            }
        }
    }
}
// MARK: - Extension
extension DetailViewController: DetailViewModelProtocol {
    func setData() {
        DispatchQueue.main.async {
            if let data = self.viewModel.movieDetail {
                ImageLoader().loadImage(with: data.posterPath, image: self.posterImageView)
                self.titleLabel.text = data.title
                self.navigationItem.title = data.title
                self.ratingLabel.text = String(data.voteAverage)
                self.releaseDateLabel.text = data.releaseDate.convertDateFormat
                self.descriptionLabel.text = data.overview
            }
        }
    }
}
