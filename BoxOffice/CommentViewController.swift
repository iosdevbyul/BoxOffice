//
//  CommentViewController.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-09.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate {

    var movieID: String = ""
    var movieTitle: String = ""
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var writerTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var rateCountLabel: UILabel!
    
    
    @IBAction func cancel(_ sender: Any) {
        if writerTextField.text != "" {
            let userDefaults = UserDefaults.standard
            userDefaults.set(writerTextField.text, forKey: "userName")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let writerTf = writerTextField else {
            return
        }
        guard let text = writerTf.text else {
            return
        }
        if text.isEmpty || commentTextView.text.isEmpty {
            let alert = UIAlertController(title: "경고", message: "닉네임 혹은 코멘트란을 채워주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else {
            addComments(rating: 5, writer: text, movie_id: movieID, contents: commentTextView.text)
        }

        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let borderColor = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)

        commentTextView.layer.borderColor = borderColor.cgColor
        
        movieTitleLabel.text = movieTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let userName = userDefaults.object(forKey: "userName")
        if userName != nil {
            writerTextField.text = userName as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        writerTextField.endEditing(true)
        commentTextView.endEditing(true)
    }
    

}
