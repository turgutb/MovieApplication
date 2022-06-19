//
//  MainViewController.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    let viewModel = MainViewModel()
    var timer = Timer()
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setUI()

    }
    

    
    // MARK: - Actions
    
    
    
    // MARK: - Functions
    private func setUI() {
        setTableView()
        setCollectionView()
        scrollView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constant.CellNibs.movieTableViewCellNib, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifiers.movieTableViewCell)
        
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constant.CellNibs.mainCollectionCellNib, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifiers.mainCollectionCell)
    }

    private func getData() {
        viewModel.delegate = self
        viewModel.getUpComing(page: viewModel.upComingPage)
        viewModel.getNowPlaying(page: viewModel.nowPlayingPage)
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func goToDetail(movieID: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        destinationVC.viewModel.mediaID = movieID
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    @objc func changeSlider() {
        if viewModel.counter < viewModel.nowPlayingNumberOfRow() {
            let index = IndexPath.init(item: viewModel.counter, section: 0)
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.collectionView.isPagingEnabled = true
            pageController.currentPage = viewModel.counter
            viewModel.counter += 1
        } else {
            viewModel.counter = 0
            let index = IndexPath.init(item: viewModel.counter, section: 0)
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.collectionView.isPagingEnabled = true
            pageController.currentPage = viewModel.counter
            viewModel.counter = 1
        }
    }
}
// MARK: - Extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upComingNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifiers.movieTableViewCell) as! MovieTableViewCell
        
        let index = viewModel.upComingCellForRow(at: indexPath.row)
        
        cell.configure(imageURL: index.posterPath, title: index.title, description: index.overview, date: index.releaseDate)

        print("tableview indexPath.row", indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModel.upComingCellForRow(at: indexPath.row)
        guard let id = vm.id else { return }
        goToDetail(movieID: id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nowPlayingNumberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifiers.mainCollectionCell, for: indexPath) as! MainCollectionViewCell
        
        let index = viewModel.nowPlayingCellForRow(at: indexPath.row)
        
        cell.configure(imageURL: index.posterPath, title: index.title, description: index.overview)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = viewModel.nowPlayingCellForRow(at: indexPath.row)
        guard let id = vm.id else { return }
        goToDetail(movieID: id)
    }

}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        switch scrollView {
        case self.scrollView:
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && viewModel.isPagination == false) {
                viewModel.isPagination = true
                viewModel.upComingPage += 1
                tableView.tableFooterView = createSpinnerFooter()
            }
        case collectionView:
            let position = collectionView.contentOffset.x
            pageController.currentPage = Int(position/collectionView.bounds.width)
            
        default:
            ()
        }
 
    }
}
extension MainViewController: MainViewModelProtocol {
    func setSlider() {
        DispatchQueue.main.async {
            self.pageController.numberOfPages = self.viewModel.nowPlayingNumberOfRow()
            self.pageController.currentPage = 0
            if self.viewModel.nowPlayingNumberOfRow() > 0 {
                self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeSlider), userInfo: nil, repeats: true)
            }
        }
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()

        }
    }
    func setTableViewHeight() {
        DispatchQueue.main.async {
            self.tableViewHeightConstant.constant = (CGFloat(self.viewModel.nowPlayingMovies.count + 1) * 140)
            self.tableView.sizeToFit()
            self.tableView.layoutIfNeeded()
        }
    }
}
