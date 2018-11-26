//
//  TableViewController.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-09.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedMovie: Movie?
    var movies: [Movie] = []
    
    let identifier: String = "movieTableCell"
    
    let refreshControl = UIRefreshControl()


    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "예매율순"
        
//        NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .done, target: self, action: #selector(reorderMovies))

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertForError(_:)), name: DidReceiveErrorNotification, object: nil)

        setOrderToUserDefaults("0")
        
        addRefreshControl()
    }

    @objc func alertForError(_ noti: Notification) {
        let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addRefreshControl() {
        movieTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc func refreshWeatherData(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        movieTableView.reloadData()
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
            self.title = "예매율순"
            self.setOrderToUserDefaults("0")
        }
        let option2: UIAlertAction = UIAlertAction(title: "큐레이션", style: .default)  { (UIAlertAction) in
            requestMovieList(type: "1")
            self.title = "큐레이션"
            self.setOrderToUserDefaults("1")
        }
        let option3: UIAlertAction = UIAlertAction(title: "개봉일", style: .default)  { (UIAlertAction) in
            requestMovieList(type: "2")
            self.title = "개봉일순"
            self.setOrderToUserDefaults("2")
        }
        let cancel: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(option3)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didReceiveMoviesNotification(_ noti: Notification) {
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else { return  }
        self.movies = movies
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        
        guard let order = userDefaults.object(forKey: "order") else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        requestMovieList(type: "\(order)")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let movie: Movie = self.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.rateLabel.text = "평점 : " + "\(movie.user_rating)" + " 예매순위 : " + "\(movie.reservation_grade)" + " 예매율 : " + "\(movie.reservation_rate)"
        cell.dateLabel.text = "개봉일 : " + "\(movie.date)"
        
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
        
        cell.movieImage.frame = CGRect(x: 10, y: 10, width: 120, height: 160)
        cell.movieImage.image = nil
        
        DispatchQueue.global().async {
            guard let imageUrl: URL = URL(string: movie.thumb) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell){
                    if index.row == indexPath.row {
                        cell.movieImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.item]
        performSegue(withIdentifier: "gotoDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
