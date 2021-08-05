//
//  ViewController.swift
//  BMG_MovieDB
//
//  Created by Abigail Aryaputra Sudarman on 03/08/21.
//

import UIKit


class ViewController: UIViewController {
    
    private var token = "a4fc6ff99237c2226086c2a0b90e1f49"
    var trendingMovies = [Movie]()
    var popularMovies = [Movie]()
  
    var movieID = 0
    
    
    var popularMoviesImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegate & data sources setup
        self.collectionViewOne.delegate = self
        self.collectionViewOne.dataSource = self
        
        
        self.collectionViewThree.delegate = self
        self.collectionViewThree.dataSource = self
        
        //Navigation Setting
        navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.tintColor = .orange
        
        //Get Datas
        self.getPopularMoviesData { result in
            
        }
        
        
        self.getTrendingMoviesData { result in
            //   self.collectionViewTwo.reloadData()
            
            
            
            self.collectionViewOne.reloadData()
            self.collectionViewThree.reloadData()
            
        }
        
        
        
    }
    
    //What's popular
    @IBOutlet weak var collectionViewOne: UICollectionView!
    
    
    //Latest Trailer
    
    
    
    //Trending
    
    
    @IBOutlet weak var watchImageView: UIImageView!
    @IBOutlet weak var collectionViewThree: UICollectionView!
    
    
    
    
    //MARK: - Func
    func getImageFromUrls(){
        
    }
    
    
    
    
    
    
    func getTrendingMoviesData(completion: @escaping (Result<Movies, Error>) -> Void) {
        print("getting trending")
        var dataTask: URLSessionDataTask?
        let trendingMoviesURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(token)&language=en-US&page=1"
        
        
        guard let url = URL(string: trendingMoviesURL) else {return}
        
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
                let jsonData = try decoder.decode(Movies.self, from: data)
                // print(jsonData)
                self.trendingMovies = jsonData.results
                
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(jsonData.results[4].backdrop_path)")
                self.watchImageView.af.setImage(withURL: url!)
                print(url)
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
    
    
    
    
    
    
    
    func getPopularMoviesData(completion: @escaping (Result<Movies, Error>) -> Void) {
        print("getting popular")
        var dataTask: URLSessionDataTask?
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(token)&language=en-US&page=1"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
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
                let jsonData = try decoder.decode(Movies.self, from: data)
                // print(jsonData)
                self.popularMovies = jsonData.results
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    self.collectionViewOne.reloadData()
                    
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
