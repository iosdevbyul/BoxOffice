//
//  Request.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-15.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import Foundation

let DidReceiveErrorNotification: Notification.Name = Notification.Name("DidReceiveError")

let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidReceiveMovies")
let DidReceiveMovieInfoNotification: Notification.Name = Notification.Name("DidReceiveMovieInfo")
let DidReceiveCommentsInfoNotification: Notification.Name = Notification.Name("DidReceiveMovieInfo")


//func requestMovieList() {
func requestMovieList(type: String) {
    let strUrl: String = "http://connect-boxoffice.run.goorm.io/movies?order_type="+type
    
    guard let url: URL = URL(string: strUrl) else {
        return
    }
    
    let session: URLSession = URLSession(configuration: .default)
    

    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("ERR : \n \(error.localizedDescription)")
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            return
        }
        guard let data = data else {
            return
        }

        do {
            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies":apiResponse.movies])
        } catch(let err) {
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            print("ERR : \n \(err.localizedDescription)")
        }
    }
    dataTask.resume()
}

func requestMovieInfo(id: String) {

    let strUrl = "http://connect-boxoffice.run.goorm.io/movie?id="+id

    guard let url: URL = URL(string: strUrl) else {
        return
    }
    
    let session: URLSession = URLSession(configuration: .default)
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            print("ERROR : \n \(error.localizedDescription)")
            return
        }
        guard let data = data else {
            return
        }
        
        do {
            let apiResponse: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            NotificationCenter.default.post(name: DidReceiveMovieInfoNotification, object: nil, userInfo: ["movieInfo":apiResponse])
        } catch(let err) {
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            print("ERR : \n \(err.localizedDescription)")
        }
    }
    dataTask.resume()
}

func requestComments(id: String) {
    let strUrl = "http://connect-boxoffice.run.goorm.io/comments?movie_id="+id
    
    guard let url: URL = URL(string: strUrl) else {
        return
    }
    
    let session: URLSession = URLSession(configuration: .default)
    
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            print("ERROR : \n \(error.localizedDescription)")
            return
        }
        guard let data = data else {
            return
        }
        
        do {
            let apiResponse: ResponseForComments = try JSONDecoder().decode(ResponseForComments.self, from: data)
            NotificationCenter.default.post(name: DidReceiveCommentsInfoNotification, object: nil, userInfo: ["commentsInfo":apiResponse.comments])
        } catch(let err) {
            NotificationCenter.default.post(name: DidReceiveErrorNotification, object: nil)
            print("ERR : \n \(err.localizedDescription)")
        }
    }
    dataTask.resume()

}


// Referenced by https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website
func addComments(rating: Int, writer: String, movie_id: String, contents: String) {
    
    struct Comment: Codable {
        let rating: Int
        let writer: String
        let movie_id: String
        let contents: String
    }
    
    let comment = Comment(rating: rating,writer: writer, movie_id: movie_id, contents: contents)
    guard let uploadData = try? JSONEncoder().encode(comment) else {
        return
    }
    
    let strUrl = "http://connect-boxoffice.run.goorm.io/comment"
    
    guard let url: URL = URL(string: strUrl) else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
                print ("server error")
                return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
        }
    }
    task.resume()
    
    
}














