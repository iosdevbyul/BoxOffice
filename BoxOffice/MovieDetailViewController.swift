//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-09-21.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var selectedMovie: MovieInfo?
    var movieId: String = ""
    var comments: [Comments] = []
    let commentIdentifier: String = "gotoComment"
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var isMoviePosterClicked: Bool = false
    var originalMoviePosterFrame: CGRect = CGRect()

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var moviePosterImageButton: UIButton!
    
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieDateLabel: UILabel!
    
    @IBOutlet weak var genreLable: UILabel!
    
    @IBOutlet weak var gradeImageView: UIImageView!
    
    @IBOutlet weak var viewForRate: UIView!
    
    @IBOutlet weak var viewForPoint: UIView!
    
    @IBOutlet weak var viewForCustomer: UIView!
    
    @IBOutlet weak var containerForMovieImageAndTitle: UIView!
    
    
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var starPointLabel: UILabel!
    
    @IBOutlet weak var numberOfCustomerLabel: UILabel!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 1.5 + 260)
        scrollView.isScrollEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieInfoNotification(_:)), name: DidReceiveMovieInfoNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCommentsInfoNotification(_:)), name: DidReceiveCommentsInfoNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(alertForError(_:)), name: DidReceiveErrorNotification, object: nil)
    }
    
    
    @objc func alertForError(_ noti: Notification) {
        let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didReceiveMovieInfoNotification(_ noti: Notification) {
        guard let selectedMovie = noti.userInfo?["movieInfo"] as? MovieInfo else { return  }
        
        self.selectedMovie = selectedMovie
        
        OperationQueue.main.addOperation {
            self.setMovieInfo()
            self.title = self.selectedMovie?.title
        }
        
    }
    
    @objc func didReceiveCommentsInfoNotification(_ noti: Notification) {
        guard let comments = noti.userInfo?["commentsInfo"] as? [Comments] else { return  }
        self.comments = comments
        
//        if comments.count > 0 {
//            displayComments(countOfComment: comments.count)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        requestMovieInfo(id: movieId)
        
        setMovieInfo()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickPosterButton(_ sender: Any) {
        if isMoviePosterClicked {
            moviePosterImageButton.frame = originalMoviePosterFrame
            self.containerForMovieImageAndTitle.addSubview(moviePosterImageButton)
            isMoviePosterClicked = false
            tabBarController?.tabBar.isHidden = false
        } else {
            originalMoviePosterFrame = moviePosterImageButton.frame
            moviePosterImageButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.navigationController?.view.addSubview(moviePosterImageButton)
            tabBarController?.tabBar.isHidden = true
            isMoviePosterClicked = true
        }
    }
    
    func setMovieInfo() {
        guard let selectedMovie: MovieInfo = selectedMovie else {
            return
        }
        
        DispatchQueue.global().async {
            guard let imageUrl: URL = URL(string: selectedMovie.image) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.moviePosterImageButton.setImage(UIImage(data: imageData), for: .normal)
            }
        }
        
        movieTitleLabel.text = selectedMovie.title
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        var imageName: String = ""
        switch selectedMovie.grade {
        case 12:
            imageName = "ic_12"
        case 15:
            imageName = "ic_15"
        case 19:
            imageName = "ic_19"
        default:
            imageName = "ic_allages"
        }
        gradeImageView.image = UIImage(named: imageName)
        
        movieDateLabel.text = selectedMovie.date + "개봉"
        movieDateLabel.font = UIFont.systemFont(ofSize: 20)
        
        genreLable.text = selectedMovie.genre + "/" + "\(selectedMovie.duration)"+"분"
        genreLable.font = UIFont.systemFont(ofSize: 19)
        
        // 예매율
        rateLabel.text = "\(selectedMovie.reservation_grade)"+"위 "+"\(selectedMovie.reservation_rate)"+"%"
        
        // 평점
        starPointLabel.text = "\(selectedMovie.user_rating)"
        
        // 누적관객수
        numberOfCustomerLabel.text = makeFormatForAdience(selectedMovie.audience)
    }
    

    func makeFormatForAdience(_ count: Int) -> String {
        let str = "\(count)"
        let strCount = str.count
        let startingPoint: Int = strCount % 3
        var result: String = ""
        var bool: Bool = false
        var i: Int = 1
        
        for c in str {
            if "\(i)" == "\(startingPoint)" && bool == false {
                result = result + "\(c)" + ","
                bool = true
            } else if (i-startingPoint)%3 == 0 {
                if i == strCount {
                    result = result + "\(c)"
                } else {
                    result = result + "\(c)" + ","
                }
            } else {
                result = result + "\(c)"
            }
            i = i + 1
        }
        return result
    }
    
    
    func setSynopsis() {
//        synopsis.text = selectedMovie?.synopsis
//        synopsis.isEditable = false
//        synopsis.isScrollEnabled = false
//        synopsis.font = synopsis.font?.withSize(20)
    }
}





















