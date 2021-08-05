//
//  DetailViewController.swift
//  BMG_MovieDB
//
//  Created by Abigail Aryaputra Sudarman on 04/08/21.
//

import UIKit

class DetailViewController: UIViewController {
    var movieTrailer: MovieTrailer?
    var movieID: Int = 0
    var movieDetail: MovieDetail?
    var trailerLink: String?
    private var token = "a4fc6ff99237c2226086c2a0b90e1f49"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Query again the movie detail
        
        getTrailerMovieData { result in
            print(self.movieTrailer)
            self.getTrailerLink(key: self.movieTrailer!.key)
            
        }
        
        getMovieDetail { result in
            
            self.setupView(result: result)
            self.taglineLabel.text = self.movieDetail?.tagline
            self.dateRuntimeLabel.text = "\(self.movieDetail!.release_date) - \(self.movieDetail!.runtime)m"
            let str = self.getSingleStringGenres(genres: self.movieDetail!.genres)
            self.genreLabel.text = str
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func playTrailerTapped(_ sender: Any) {
        guard let url = URL(string: trailerLink!)
        else {return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var taglineLabel: UILabel!

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var dateRuntimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    //Get detail
    
    
    func getTrailerMovieData(completion: @escaping (Result<MovieTrailers, Error>) -> Void) {
        print("getting Trailer")
        var dataTask: URLSessionDataTask?
        var baseURL = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(token)&language=en-US"
        print(baseURL)
        
        guard let url = URL(string: baseURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieTrailers.self, from: data)
                // print(jsonData)
                self.movieTrailer = jsonData.results.first
                // Back to the main thread
                print(jsonData)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    //self.collectionViewTwo.reloadData()
                    
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    
    func getMovieDetail(completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        print("getting discovery")
        var dataTask: URLSessionDataTask?
        let movieDetailUrl = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(token)&language=en-US"
        
        
        guard let url = URL(string: movieDetailUrl) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieDetail.self, from: data)
                // print(jsonData)
                print(data)
                self.movieDetail = jsonData
               
                // Back to the main thread
                
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    //self.collectionViewTwo.reloadData()
                    
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
    
    
    func getTrailerLink(key: String){
        var trailerUrl: String
        var youtubeBaseUrl = "https://www.youtube.com/watch?v="
        trailerUrl = youtubeBaseUrl + key
        
        self.trailerLink = trailerUrl
      //  print(trailerUrl)
    }
    
    
    func setupView(result: Result<MovieDetail,Error>){
        print(self.movieDetail?.backdrop_path)
        
       
        do {
            
            //Setup View
            let result = try result.get()
            self.titleLabel.text = result.title
            self.overviewLabel.text = result.overview
            self.taglineLabel.text = result.tagline
           
            let backdropImageUrl = try URL(string: "https://image.tmdb.org/t/p/w500/\(result.backdrop_path)")
            self.backdropImageView.load(url: (backdropImageUrl)!)
            
            let posterImageUrl = try URL(string: "https://image.tmdb.org/t/p/w300/\(result.poster_path)")
            self.posterImageView.load(url: (posterImageUrl)!)
            self.userScoreLabel.text = "\(result.vote_average)"
            
        } catch {
            print("error fetching image")
            
        }
        
    }
    func getSingleStringGenres(genres: [Genre]) -> String{
        var str = ""
        for i in genres {
            str = str + " \(i.name) "
        }
        return str
    }
}
