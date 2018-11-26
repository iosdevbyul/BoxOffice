//
//  DetailInfoViewController.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-09.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit

class DetailInfoViewController: UIViewController {
    
    var selectedMovie: MovieInfo?
    var movieId: String = ""
    var comments: [Comments] = []
    let commentIdentifier: String = "gotoComment"
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    let scrollView: UIScrollView = UIScrollView()
    // Subviews on the scrollView
    let moviePosterAndInfosView: UIView = UIView()
    let synopsisView: UIView = UIView()
    let directorAndActorsInfoView: UIView = UIView()
    let commentsView: UIView = UIView()
    
    let containerForMovieImageAndTitle: UIView = UIView()
    let moviePoster: UIButton = UIButton()
    var originalMoviePosterFrame: CGRect = CGRect()
    var isMoviePosterClicked: Bool = false
    let containerForRate: UIView = UIView()
    let containerForUserRate: UIView = UIView()
    let containerForNumber: UIView = UIView()
    let rateTitleLabel: UILabel = UILabel()
    let rateLabel: UILabel = UILabel()
    let userRateTitleLabel: UILabel = UILabel()
    let userRateLabel: UILabel = UILabel()
    let customerNumberTitleLabel: UILabel = UILabel()
    let customerNumberLabel: UILabel = UILabel()
    let gradeImage: UIImageView = UIImageView()
    
    let star1: UIImageView = UIImageView()
    let star2: UIImageView = UIImageView()
    let star3: UIImageView = UIImageView()
    let star4: UIImageView = UIImageView()
    let star5: UIImageView = UIImageView()
    
    let synopsis: UITextView = UITextView()
    let synopsisTitleLabel: UILabel = UILabel()
    
    let directorInfo: UILabel = UILabel()
    let actorInfo: UILabel = UILabel()
    
    let writeCommentButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieInfoNotification(_:)), name: DidReceiveMovieInfoNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCommentsInfoNotification(_:)), name: DidReceiveCommentsInfoNotification, object: nil)
        
        self.view.topAnchor.constraint(equalTo: super.view.topAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: super.view.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: super.view.trailingAnchor).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(alertForError(_:)), name: DidReceiveErrorNotification, object: nil)
    }

    @objc func alertForError(_ noti: Notification) {
        let alert = UIAlertController(title: "Error", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

//        commentsView
        
        requestMovieInfo(id: movieId)
        
        
    }
    
    @objc func didReceiveMovieInfoNotification(_ noti: Notification) {
        guard let selectedMovie = noti.userInfo?["movieInfo"] as? MovieInfo else { return  }

        self.selectedMovie = selectedMovie
        
        print("selectedMovie.title : \(selectedMovie.title)")
        
        
        OperationQueue.main.addOperation {
            self.title = selectedMovie.title
            self.createScrollView()
            
        }
        
        
        
    }
    
    @objc func didReceiveCommentsInfoNotification(_ noti: Notification) {
        guard let comments = noti.userInfo?["commentsInfo"] as? [Comments] else { return  }
         self.comments = comments

        if comments.count > 0 {
            displayComments(countOfComment: comments.count)
        }
    }

    func createScrollView() {
        self.scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 2)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.white

        scrollView.addSubview(createMovieBasicInfo(view: moviePosterAndInfosView))
        scrollView.addSubview(createSynopsisViewAndItems(synopsisView: synopsisView))
        scrollView.addSubview(createDirectorAndActorsInfoView(directorAndActorsInfoView: directorAndActorsInfoView))
        scrollView.addSubview(createCommentsView(commentsView: commentsView))
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        scrollView.addSubview(moviePosterAndInfosView)
        
//        OperationQueue.main.addOperation {
            self.createConstraintForViewsOnScrollView()
//        }
        
    }
    
    func createConstraintForViewsOnScrollView() {
        //1
        moviePosterAndInfosView.translatesAutoresizingMaskIntoConstraints = false
        let moviePosterAndInfosViewLeadingConstraint = NSLayoutConstraint(item: moviePosterAndInfosView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let moviePosterAndInfosViewTrailingConstraint = NSLayoutConstraint(item: moviePosterAndInfosView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let moviePosterAndInfosViewTopConstraint = NSLayoutConstraint(item: moviePosterAndInfosView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let moviePosterAndInfosViewWidthConstraint = NSLayoutConstraint(item: moviePosterAndInfosView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let moviePosterAndInfosViewHeightConstraint = NSLayoutConstraint(item: moviePosterAndInfosView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 400)
        
        NSLayoutConstraint.activate([moviePosterAndInfosViewLeadingConstraint, moviePosterAndInfosViewTrailingConstraint, moviePosterAndInfosViewTopConstraint, moviePosterAndInfosViewWidthConstraint, moviePosterAndInfosViewHeightConstraint])
        
        containerForRate.translatesAutoresizingMaskIntoConstraints = false
        
        let containerForRateLeadingConstraint = NSLayoutConstraint(item: containerForRate, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: moviePosterAndInfosView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
        let containerForRateTrailingConstraint = NSLayoutConstraint(item: containerForRate, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: moviePosterAndInfosView, attribute: NSLayoutAttribute.trailing, multiplier: 0.3, constant: 10)
        let containerForRateTopConstraint = NSLayoutConstraint(item: containerForRate, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 0.7, constant: 0)
        let containerForRateBottomConstraint = NSLayoutConstraint(item: containerForRate, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10)
    NSLayoutConstraint.activate([containerForRateLeadingConstraint,containerForRateTrailingConstraint,containerForRateTopConstraint,containerForRateBottomConstraint])
        
        containerForUserRate.translatesAutoresizingMaskIntoConstraints = false
        let containerForUserRateLeadingConstraint = NSLayoutConstraint(item: containerForUserRate, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerForRate, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        let containerForUserRateTrailingConstraint = NSLayoutConstraint(item: containerForUserRate, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: containerForUserRate, attribute: NSLayoutAttribute.leading, multiplier: 2, constant: -20)
        let containerForUserRateTopConstraint = NSLayoutConstraint(item: containerForUserRate, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 0.7, constant: 0)
        let containerForUserRateBottomConstraint = NSLayoutConstraint(item: containerForUserRate, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10)
    NSLayoutConstraint.activate([containerForUserRateLeadingConstraint,containerForUserRateTrailingConstraint,containerForUserRateTopConstraint,containerForUserRateBottomConstraint])
        
        containerForNumber.translatesAutoresizingMaskIntoConstraints = false
        
        let containerForNumberLeadingConstraint = NSLayoutConstraint(item: containerForNumber, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: containerForUserRate, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        let containerForNumberTrailingConstraint = NSLayoutConstraint(item: containerForNumber, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10)
        let containerForNumberTopConstraint = NSLayoutConstraint(item: containerForNumber, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 0.7, constant: 0)
        let containerForNumberBottomConstraint = NSLayoutConstraint(item: containerForNumber, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10)
        NSLayoutConstraint.activate([containerForNumberLeadingConstraint,containerForNumberTrailingConstraint,containerForNumberTopConstraint,containerForNumberBottomConstraint])
        
        rateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateTitleLabel.centerXAnchor.constraint(equalTo: containerForRate.centerXAnchor).isActive = true
        rateTitleLabel.topAnchor.constraint(equalTo: containerForRate.topAnchor, constant: 20).isActive = true
        rateLabel.centerXAnchor.constraint(equalTo: containerForRate.centerXAnchor).isActive = true
        rateLabel.topAnchor.constraint(equalTo: containerForRate.topAnchor, constant: 50).isActive = true
        
        userRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userRateLabel.translatesAutoresizingMaskIntoConstraints = false
        userRateTitleLabel.centerXAnchor.constraint(equalTo: containerForUserRate.centerXAnchor).isActive = true
        userRateTitleLabel.topAnchor.constraint(equalTo: containerForUserRate.topAnchor, constant: 20).isActive = true
        userRateLabel.centerXAnchor.constraint(equalTo: containerForUserRate.centerXAnchor).isActive = true
        userRateLabel.topAnchor.constraint(equalTo: containerForUserRate.topAnchor, constant: 50).isActive = true
        
        customerNumberTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customerNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        customerNumberTitleLabel.centerXAnchor.constraint(equalTo: containerForNumber.centerXAnchor).isActive = true
        customerNumberTitleLabel.topAnchor.constraint(equalTo: containerForNumber.topAnchor, constant: 20).isActive = true
        customerNumberLabel.centerXAnchor.constraint(equalTo: containerForNumber.centerXAnchor).isActive = true
        customerNumberLabel.topAnchor.constraint(equalTo: containerForNumber.topAnchor, constant: 50).isActive = true
        
        gradeImage.translatesAutoresizingMaskIntoConstraints = false
        gradeImage.trailingAnchor.constraint(equalTo: self.moviePosterAndInfosView.trailingAnchor, constant: -10).isActive = true
        gradeImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        gradeImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        star1.translatesAutoresizingMaskIntoConstraints = false
        star2.translatesAutoresizingMaskIntoConstraints = false
        star3.translatesAutoresizingMaskIntoConstraints = false
        star4.translatesAutoresizingMaskIntoConstraints = false
        star5.translatesAutoresizingMaskIntoConstraints = false
        
        star1.heightAnchor.constraint(equalToConstant: 15).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 15).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 15).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 15).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 15).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 15).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 15).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        star1.bottomAnchor.constraint(equalTo: containerForUserRate.bottomAnchor, constant: -5).isActive = true
        star2.bottomAnchor.constraint(equalTo: containerForUserRate.bottomAnchor, constant: -5).isActive = true
        star3.bottomAnchor.constraint(equalTo: containerForUserRate.bottomAnchor, constant: -5).isActive = true
        star4.bottomAnchor.constraint(equalTo: containerForUserRate.bottomAnchor, constant: -5).isActive = true
        star5.bottomAnchor.constraint(equalTo: containerForUserRate.bottomAnchor, constant: -5).isActive = true
        
        

        star3.centerXAnchor.constraint(equalTo: containerForUserRate.centerXAnchor).isActive = true
        star2.trailingAnchor.constraint(equalTo: star3.leadingAnchor, constant: -5).isActive = true
        star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor, constant: 5).isActive = true
        star1.trailingAnchor.constraint(equalTo: star2.leadingAnchor, constant: -5).isActive = true
        star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor, constant: 5).isActive = true
        
        //2
        synopsisView.translatesAutoresizingMaskIntoConstraints = false
        
        let synopsisViewLeadingConstraint = NSLayoutConstraint(item: synopsisView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let synopsisViewTrailingConstraint = NSLayoutConstraint(item: synopsisView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let synopsisViewViewTopConstraint = NSLayoutConstraint(item: synopsisView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.moviePosterAndInfosView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let synopsisViewViewWidthConstraint = NSLayoutConstraint(item: synopsisView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let synopsisViewViewHeightConstraint = NSLayoutConstraint(item: synopsisView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 800)
    NSLayoutConstraint.activate([synopsisViewLeadingConstraint,synopsisViewTrailingConstraint,synopsisViewViewTopConstraint,synopsisViewViewWidthConstraint,synopsisViewViewHeightConstraint])
        
        synopsisTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        synopsisTitleLabel.topAnchor.constraint(equalTo: synopsisView.topAnchor, constant: 10).isActive = true
        synopsisTitleLabel.bottomAnchor.constraint(equalTo: synopsis.topAnchor, constant: -10).isActive = true
        synopsisTitleLabel.leadingAnchor.constraint(equalTo: synopsisView.leadingAnchor, constant: 10).isActive = true
        synopsisTitleLabel.topAnchor.constraint(equalTo: synopsisView.topAnchor, constant: 10).isActive = true
        
        synopsis.translatesAutoresizingMaskIntoConstraints = false
        synopsis.leadingAnchor.constraint(equalTo: synopsisView.leadingAnchor, constant: 10).isActive = true
        synopsis.trailingAnchor.constraint(equalTo: synopsisView.trailingAnchor, constant: -10).isActive = true
        synopsis.bottomAnchor.constraint(equalTo: synopsisView.bottomAnchor, constant: -10).isActive = true
        synopsis.topAnchor.constraint(equalTo: synopsisTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        //3
        directorAndActorsInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let directorAndActorsInfoViewLeadingConstraint = NSLayoutConstraint(item: directorAndActorsInfoView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let directorAndActorsInfoViewTrailingConstraint = NSLayoutConstraint(item: directorAndActorsInfoView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let directorAndActorsInfoViewTopConstraint = NSLayoutConstraint(item: directorAndActorsInfoView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.synopsisView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let directorAndActorsInfoViewWidthConstraint = NSLayoutConstraint(item: directorAndActorsInfoView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let directorAndActorsInfoViewHeightConstraint = NSLayoutConstraint(item: directorAndActorsInfoView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
        NSLayoutConstraint.activate([directorAndActorsInfoViewLeadingConstraint,directorAndActorsInfoViewTrailingConstraint,directorAndActorsInfoViewTopConstraint,directorAndActorsInfoViewWidthConstraint,directorAndActorsInfoViewHeightConstraint])
        
        actorInfo.translatesAutoresizingMaskIntoConstraints = false
        actorInfo.leadingAnchor.constraint(equalTo: directorInfo.leadingAnchor, constant: 0).isActive = true
        actorInfo.topAnchor.constraint(equalTo: directorInfo.bottomAnchor, constant: 10).isActive = true
        actorInfo.trailingAnchor.constraint(equalTo: directorAndActorsInfoView.trailingAnchor, constant: -10).isActive = true

        
        //4
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        
        let commentsViewLeadingConstraint = NSLayoutConstraint(item: commentsView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let commentsViewTrailingConstraint = NSLayoutConstraint(item: commentsView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let commentsViewTopConstraint = NSLayoutConstraint(item: commentsView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.directorAndActorsInfoView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let commentsViewWidthConstraint = NSLayoutConstraint(item: commentsView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let commentsViewHeightConstraint = NSLayoutConstraint(item: commentsView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(100 * comments.count + 140))
        NSLayoutConstraint.activate([commentsViewLeadingConstraint,commentsViewTrailingConstraint,commentsViewTopConstraint,commentsViewWidthConstraint,commentsViewHeightConstraint])
        
        writeCommentButton.translatesAutoresizingMaskIntoConstraints = false
        writeCommentButton.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: -10).isActive = true
        writeCommentButton.topAnchor.constraint(equalTo: commentsView.topAnchor, constant: 30).isActive = true
    }
    
    func createMovieBasicInfo(view: UIView) -> UIView{
        view.frame.size.width = screenWidth
        view.frame.size.height = screenHeight / 2
        
        view.frame.origin.x = 0
        view.frame.origin.y = 0
        view.backgroundColor = UIColor.white
        
        setItems(basedView: view)
        
        return view
    }
    
    func setItems(basedView: UIView) {
        //1
        containerForMovieImageAndTitle.frame = CGRect(x: 0, y: 0, width: basedView.frame.size.width, height: basedView.frame.size.height * 0.67)
        
        //image
        moviePoster.frame = CGRect(x: 10, y: 10, width: (containerForMovieImageAndTitle.bounds.height - 20)/4*3, height: containerForMovieImageAndTitle.bounds.height - 20)
        moviePoster.addTarget(self, action: #selector(clickMoviePoster), for: .touchUpInside)
        
        guard let selectedMovie: MovieInfo = selectedMovie else {
            return
        }
        DispatchQueue.global().async {
            guard let imageUrl: URL = URL(string: selectedMovie.image) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.moviePoster.setImage(UIImage(data: imageData), for: .normal)
            }
        }
        containerForMovieImageAndTitle.addSubview(moviePoster)
        
        //labels
        let titleLable: UILabel = UILabel(frame:CGRect(x: moviePoster.bounds.width + 15, y: 45.0, width: screenWidth - moviePoster.bounds.width - 15, height: 40.0))
        titleLable.text = selectedMovie.title
        titleLable.font = UIFont.boldSystemFont(ofSize: 19)
        containerForMovieImageAndTitle.addSubview(titleLable)
        gradeImage.frame = CGRect(x: titleLable.frame.origin.x + titleLable.frame.size.width - 30 , y: titleLable.frame.origin.y, width: 30, height: 30)
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
        gradeImage.image = UIImage(named: imageName)
        containerForMovieImageAndTitle.addSubview(gradeImage)
        
        let dateLable: UILabel = UILabel(frame:CGRect(x: moviePoster.bounds.width + 15, y: 90.0, width: screenWidth - moviePoster.bounds.width - 15, height: 40.0))
        dateLable.text = selectedMovie.date + "개봉"
        dateLable.font = UIFont.systemFont(ofSize: 20)
        containerForMovieImageAndTitle.addSubview(dateLable)
        let genreLable: UILabel = UILabel(frame:CGRect(x: moviePoster.bounds.width + 15, y: 135.0, width: screenWidth - moviePoster.bounds.width - 15, height: 70.0))
        genreLable.text = selectedMovie.genre + "/" + "\(selectedMovie.duration)"+"분"
        genreLable.font = UIFont.systemFont(ofSize: 19)
        genreLable.numberOfLines = 2
        containerForMovieImageAndTitle.addSubview(genreLable)
        
        basedView.addSubview(containerForMovieImageAndTitle)

        //2
        containerForRate.frame = CGRect(x: 0, y: containerForMovieImageAndTitle.bounds.height + 4, width: basedView.frame.width / 3 - 4, height: basedView.frame.height - 8 - containerForMovieImageAndTitle.frame.height)
        containerForRate.backgroundColor = UIColor.white
        rateTitleLabel.frame = CGRect(x: 10, y: 10, width: containerForRate.frame.width - 20, height: 40)
        rateTitleLabel.text = "예매율"
        rateTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        rateTitleLabel.textAlignment = .center
        rateLabel.frame = CGRect(x: 10, y: 50, width: containerForRate.frame.width - 20, height: 40)
        rateLabel.text = "\(selectedMovie.reservation_grade)"+"위 "+"\(selectedMovie.reservation_rate)"+"%"
        rateLabel.textAlignment = .center
        containerForRate.addSubview(rateTitleLabel)
        containerForRate.addSubview(rateLabel)
        basedView.addSubview(containerForRate)
        
        //3
        containerForUserRate.frame = CGRect(x: basedView.frame.width / 3 + 2, y: containerForMovieImageAndTitle.bounds.height + 4, width: basedView.frame.width / 3 - 4, height: basedView.frame.height - 8 - containerForMovieImageAndTitle.frame.height)
        containerForUserRate.backgroundColor = UIColor.white
        userRateTitleLabel.frame = CGRect(x: 10, y: 10, width: containerForRate.frame.width - 20, height: 40)
        userRateTitleLabel.text = "평점"
        userRateTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userRateTitleLabel.textAlignment = .center
        userRateLabel.frame = CGRect(x: 10, y: 40, width: containerForUserRate.frame.width - 20, height: 40)
        userRateLabel.text = "\(selectedMovie.user_rating)"
        userRateLabel.textAlignment = .center
        containerForUserRate.addSubview(userRateTitleLabel)
        containerForUserRate.addSubview(userRateLabel)
        basedView.addSubview(containerForUserRate)
        
        // star
        
        
        star1.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        star1.image = UIImage(named: "ic_star_large_full")
        star2.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        star2.image = UIImage(named: "ic_star_large_full")
        star3.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        star3.image = UIImage(named: "ic_star_large_full")
        star4.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        star4.image = UIImage(named: "ic_star_large_full")
        star5.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        star5.image = UIImage(named: "ic_star_large_full")
        
        let rating = selectedMovie.user_rating
        
        /*
         ic_star_large
         ic_star_large_full
         ic_star_large_half
         */
        
        if rating <= 2 {
            star2.image = UIImage(named: "ic_star_large")
            star3.image = UIImage(named: "ic_star_large")
            star4.image = UIImage(named: "ic_star_large")
            star5.image = UIImage(named: "ic_star_large")
            
            if rating < 1 {
                star1.image = UIImage(named: "ic_star_large")
            } else {
                star1.image = UIImage(named: "ic_star_large_half")
            }
        } else if rating <= 4 {
            star1.image = UIImage(named: "ic_star_large_full")
            
            star3.image = UIImage(named: "ic_star_large")
            star4.image = UIImage(named: "ic_star_large")
            star5.image = UIImage(named: "ic_star_large")
            
            if rating < 3 {
                star2.image = UIImage(named: "ic_star_large")
            } else {
                star2.image = UIImage(named: "ic_star_large_half")
            }
        } else if rating <= 6 {
            star1.image = UIImage(named: "ic_star_large_full")
            star2.image = UIImage(named: "ic_star_large_full")
            
            star4.image = UIImage(named: "ic_star_large")
            star5.image = UIImage(named: "ic_star_large")
            
            if rating < 5 {
                star3.image = UIImage(named: "ic_star_large")
            } else {
                star3.image = UIImage(named: "ic_star_large_half")
            }
        } else if rating <= 8 {
            star1.image = UIImage(named: "ic_star_large_full")
            star2.image = UIImage(named: "ic_star_large_full")
            star3.image = UIImage(named: "ic_star_large_full")
            
            star5.image = UIImage(named: "ic_star_large")
            
            if rating < 7 {
                star4.image = UIImage(named: "ic_star_large")
            } else {
                star4.image = UIImage(named: "ic_star_large_half")
            }
        } else {
            
        }
        
        basedView.addSubview(star1)
        basedView.addSubview(star2)
        basedView.addSubview(star3)
        basedView.addSubview(star4)
        basedView.addSubview(star5)
        
        
        //4
        containerForNumber.frame = CGRect(x: basedView.frame.width / 3 * 2 + 4, y: containerForMovieImageAndTitle.bounds.height + 4, width: basedView.frame.width / 3 - 4, height: basedView.frame.height - 8 - containerForMovieImageAndTitle.frame.height)
        containerForNumber.backgroundColor = UIColor.white
        customerNumberTitleLabel.frame = CGRect(x: 10, y: 10, width: containerForRate.frame.width - 20, height: 40)
        customerNumberTitleLabel.text = "누적관객수"
        customerNumberTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        customerNumberTitleLabel.textAlignment = .center
        customerNumberLabel.frame = CGRect(x: 10, y: 50, width: containerForNumber.frame.width - 20, height: 40)
        customerNumberLabel.text = makeFormatForAdience(selectedMovie.audience)
        customerNumberLabel.textAlignment = .center
        containerForNumber.addSubview(customerNumberTitleLabel)
        containerForNumber.addSubview(customerNumberLabel)
        basedView.addSubview(containerForNumber)
    }
    
    @objc func clickMoviePoster() {
        
        if isMoviePosterClicked {
            moviePoster.frame = originalMoviePosterFrame
            self.containerForMovieImageAndTitle.addSubview(moviePoster)
            isMoviePosterClicked = false
            tabBarController?.tabBar.isHidden = false
        } else {
            originalMoviePosterFrame = moviePoster.frame
            moviePoster.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.navigationController?.view.addSubview(moviePoster)
            tabBarController?.tabBar.isHidden = true
            isMoviePosterClicked = true
        }
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
    
    func createSynopsisViewAndItems(synopsisView: UIView) -> UIView {
        synopsisView.frame.size.width = screenWidth
        synopsisView.frame.size.height = screenHeight
        synopsisView.frame.origin.x = 0
        synopsisView.frame.origin.y = moviePosterAndInfosView.frame.size.height + moviePosterAndInfosView.frame.origin.y + 30
        synopsisView.backgroundColor = UIColor.white
        
        
        setItemsForSynopsisView(basedView: synopsisView)
        
        return synopsisView
    }
    
    func setItemsForSynopsisView(basedView: UIView) {
        synopsisTitleLabel.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        synopsisTitleLabel.text = "줄거리"
        synopsisTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        basedView.addSubview(synopsisTitleLabel)
        
        synopsis.frame = CGRect(x: 10, y: 30, width: screenWidth - 20, height: screenHeight * 0.7)
        synopsis.text = selectedMovie?.synopsis
        synopsis.isEditable = false
        synopsis.isScrollEnabled = false
        synopsis.font = synopsis.font?.withSize(20)
        basedView.addSubview(synopsis)
    }
    
    func createDirectorAndActorsInfoView(directorAndActorsInfoView: UIView) -> UIView {
        directorAndActorsInfoView.frame = CGRect(x: 0, y: synopsisView.frame.origin.y + synopsisView.frame.size.height + 30, width: screenWidth, height: 200)
        setItemsFoActorsInfo(basedView: directorAndActorsInfoView)
        directorAndActorsInfoView.backgroundColor = UIColor.white
        return directorAndActorsInfoView
    }
    
    func setItemsFoActorsInfo(basedView: UIView) {
        
        guard let selectedMovie = selectedMovie else {
            return
        }
        
        let title: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100 , height: 50))
        title.text = "감독/출연"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        basedView.addSubview(title)
        
        let directorTitle: UILabel = UILabel(frame: CGRect(x: 20, y: 70, width: 100, height: 50))
        directorTitle.text = "감독"
        basedView.addSubview(directorTitle)
        
        directorInfo.frame = CGRect(x: 130, y: 70, width: 150, height: 50)
        directorInfo.text = selectedMovie.director
        basedView.addSubview(directorInfo)

        let actorTitle: UILabel = UILabel(frame: CGRect(x: 20, y: 110, width: 100, height: 50))
        actorTitle.text = "출연"
        basedView.addSubview(actorTitle)
        
        actorInfo.frame = CGRect(x: 130, y: 100, width: screenWidth - 140, height: 80)
        actorInfo.text = selectedMovie.actor
        actorInfo.numberOfLines = 2
        basedView.addSubview(actorInfo)
    }
    
    func createCommentsView(commentsView: UIView) -> UIView {
        commentsView.frame = CGRect(x: 0, y: directorAndActorsInfoView.frame.origin.y + directorAndActorsInfoView.frame.size.height + 30 , width: screenWidth, height: 200)
        setItemsForComments(basedView: commentsView)
        commentsView.backgroundColor = UIColor.white
        return commentsView
    }
    
    func setItemsForComments(basedView: UIView) {
        let title: UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
        title.text = "한줄평"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        basedView.addSubview(title)
        
        writeCommentButton.frame = CGRect(x: screenWidth - 40, y: 10, width: 30, height: 30)
        writeCommentButton.setImage(UIImage(named: "btn_compose"), for: UIControlState.normal)
        writeCommentButton.addTarget(self, action: #selector(touchedWriteCommentButton), for: UIControlEvents.touchUpInside)
        basedView.addSubview(writeCommentButton)
        
        requestComments(id: (selectedMovie?.id)!)
    }
    
    @objc func touchedWriteCommentButton(_ button: UIButton) {
        performSegue(withIdentifier: commentIdentifier, sender: nil)
        
    }
    
    func displayComments(countOfComment: Int) {
        var index = 0
        
        while index < countOfComment {
            createCommentView(index)
            index += 1
            
        }
        OperationQueue.main.addOperation {
            self.commentsView.frame.size = CGSize(width: self.screenWidth, height: CGFloat(100 * countOfComment + 70))
        }
        
        
    }
    
    func createCommentView(_ index: Int) {
        
        
        OperationQueue.main.addOperation {
            let newCommentView: UIView = UIView(frame: CGRect(x: 0.0, y: 100.0 * Double(index) + 70.0, width: Double(self.screenWidth * 0.8), height: 100.0))
            
            self.createItemsForCommentView(newCommentView, index)
            
            self.commentsView.addSubview(newCommentView)
            
            self.scrollView.contentSize = CGSize(width: self.screenWidth, height: 100.0 * CGFloat(index) + 70.0 + self.screenHeight * 1.5 + 410)
        }
    }
    
    func createItemsForCommentView(_ view: UIView, _ index: Int) {
        let profileImage: UIImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 65, height: 65))
        let rateImage: UIImageView = UIImageView(frame: CGRect(x: screenWidth * 0.3 + 20, y: 10, width: 20, height: 20))
        let name: UILabel = UILabel(frame: CGRect(x: 95, y: 10, width: screenWidth * 0.3, height: 20))
        let dateAndTime: UILabel = UILabel(frame: CGRect(x: 95, y: 40, width: screenWidth * 0.5, height: 20))
        let content: UILabel = UILabel(frame: CGRect(x: 95, y: 70, width: screenWidth * 0.7, height: 20))
        
        profileImage.image = UIImage(named: "ic_user_loading")
        name.text = comments[index].writer
        content.text = comments[index].contents
        
        // Referenced by https://stackoverflow.com/questions/40648284/converting-a-unix-timestamp-into-date-as-string-swift
        let unixTimeInterval = comments[index].timestamp
        let date = Date(timeIntervalSince1970: unixTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        dateAndTime.text = strDate
        
//        let rate: Double = comments[index].rating
        
        view.addSubview(profileImage)
        view.addSubview(rateImage)
        view.addSubview(name)
        view.addSubview(dateAndTime)
        view.addSubview(content)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == commentIdentifier {
            guard let nextViewController: CommentViewController = segue.destination as? CommentViewController else {
                return
            }
            
            guard let selectedMovie = selectedMovie else {
                return
            }
            
            nextViewController.movieID = selectedMovie.id
            nextViewController.movieTitle = selectedMovie.title
        }
    }
    
}
