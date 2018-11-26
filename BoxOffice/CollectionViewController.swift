//
//  CollectionViewController.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-09.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var selectedMovie: Movie?
    var movies: [Movie] = []
    let refreshControl = UIRefreshControl()
    enum Sorting {
        case bookingRate
        case curation
        case releaseDate
    }

    @IBOutlet weak var collectionView: UICollectionView!
    let identifier: String = "movieCollectionCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .done, target: self, action: #selector(reorderMovies))
        addRefreshControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(alertForError(_:)), name: DidReceiveErrorNotification, object: nil)
    }
    
    
    @objc func alertForError(_ noti: Notification) {
        let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc func refreshWeatherData(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setOrderToUserDefaults(_ order: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(order, forKey: "order")
    }
    
    @objc func reorderMovies() {
        //UIAction
        let alert: UIAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        let option1: UIAlertAction = UIAlertAction(title: "예매율", style: .default) { (UIAlertAction) in
            requestMovieList(type: "0")
            self.setOrderToUserDefaults("0")
            self.title = "예매율순"
        }
        let option2: UIAlertAction = UIAlertAction(title: "큐레이션", style: .default)  { (UIAlertAction) in
            requestMovieList(type: "1")
            self.setOrderToUserDefaults("1")
            self.title = "큐레이션"
        }
        let option3: UIAlertAction = UIAlertAction(title: "개봉일", style: .default)  { (UIAlertAction) in
            requestMovieList(type: "2")
            self.setOrderToUserDefaults("2")
            self.title = "개봉일순"
        }
        let cancel: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(option3)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        guard let order = userDefaults.object(forKey: "order") else {
            return
        }
        requestMovieList(type: "\(order)")
        
        if "\(order)" == "0" {
            self.title = "예매율순"
        } else if "\(order)" == "1" {
            self.title = "큐레이션"
        } else {
            self.title = "개봉일순"
        }
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else { return  }

        self.movies = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movie = self.movies[indexPath.item]
        
        cell.titleLabel.text = movie.title
        cell.titleLabel.textAlignment = .center
        cell.rateLabel.text = "\(movie.reservation_grade)" + "위(" + "\(movie.user_rating)" + ") / " + "\(movie.reservation_rate)" + "%"
        cell.rateLabel.textAlignment = .center
        cell.dateLabel.text = "\(movie.date)"
        cell.dateLabel.textAlignment = .center
        
        switch movie.grade {
        case 12:
            cell.gradeImage.image = UIImage(named: "ic_12")
        case 15:
            cell.gradeImage.image = UIImage(named: "ic_15")
        case 19:
            cell.gradeImage.image = UIImage(named: "ic_19")
        default:
            cell.gradeImage.image = UIImage(named: "ic_allages")
        }
        
        cell.movieImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height-60)
        cell.titleLabel.frame = CGRect(x: 0, y: cell.frame.height - 60, width: cell.frame.width, height: 20)
        cell.rateLabel.frame = CGRect(x: 0, y: cell.frame.height - 40, width: cell.frame.width, height: 20)
        cell.dateLabel.frame = CGRect(x: 0, y: cell.frame.height - 20, width: cell.frame.width, height: 20)
        
        DispatchQueue.global().async {
            guard let imageUrl: URL = URL(string: movie.thumb) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                if let index: IndexPath = collectionView.indexPath(for: cell){
                    if index.item == indexPath.item {
                        cell.movieImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIApplication.shared.statusBarOrientation
        var screenWidth: CGFloat = 0
        var cellSize: CGSize = CGSize()
        
        //landscape
        if ((orientation == .landscapeLeft) || (orientation == .landscapeRight)) {
            screenWidth = UIScreen.main.bounds.height
        } else { //portrait
            screenWidth = UIScreen.main.bounds.width
        }
        
        let appropriateCellWidth = screenWidth / 2 - 10

        
        cellSize = CGSize(width: appropriateCellWidth, height: appropriateCellWidth * 2)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.item]
        performSegue(withIdentifier: "gotoDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetail" {
            let nextViewController = segue.destination as! DetailInfoViewController
            guard let selectedMovie = selectedMovie else {
                return
            }
            nextViewController.movieId = selectedMovie.id
            
        }
    }
    
    
}
