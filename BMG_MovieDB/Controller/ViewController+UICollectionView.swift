//
//  ViewController+UICollectionView.swift
//  BMG_MovieDB
//
//  Created by Abigail Aryaputra Sudarman on 04/08/21.
//

import Foundation
import UIKit
import AlamofireImage


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewOne {
            return popularMovies.count
        }
       
        return trendingMovies.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewOne {
            let cell = collectionViewOne.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewOneCell
          
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCell(sender:)))
            tapRecognizer.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tapRecognizer)
            
           // cell.textLabel.text = popularMovies[indexPath.row].title
            cell.imageView.af.setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w300/\(popularMovies[indexPath.row].poster_path)")!, placeholderImage: UIImage(named: "placeholder"))
            
            cell.movieID = popularMovies[indexPath.row].id
            //  print(popularMovies[indexPath.row].title)
            
            return cell
            
        }  else {
            let cell = collectionViewThree.dequeueReusableCell(withReuseIdentifier: "customCell3", for: indexPath) as! CustomCollectionViewThreeCell
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCell(sender:)))
            tapRecognizer.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tapRecognizer)
            
          //  cell.textLabel.text = trendingMovies[indexPath.row].title
            cell.imageView.af.setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w300/\(trendingMovies[indexPath.row].poster_path)")!, placeholderImage: UIImage(named: "placeholder"))
            cell.movieID = trendingMovies[indexPath.row].id
            return cell
        }
        
    }
    
    @objc func tapCell(sender: UITapGestureRecognizer?){
        if let tapCell = sender {
            
            if let cellOwner = tapCell.view as? CustomCollectionViewOneCell {
               
                self.movieID = cellOwner.movieID
                print("from cell one")
                performSegue(withIdentifier: "watchToDetail", sender: Any?.self)
                
            }else   if let cellOwner = tapCell.view as? CustomCollectionViewThreeCell  {
              
                self.movieID = cellOwner.movieID
                print("from cell three")
                performSegue(withIdentifier: "watchToDetail", sender: Any?.self)
            }
            
        }
    }
    
    
    
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! DetailViewController
            
           
            destinationVC.movieID = movieID
            print(movieID)
    
        }
    
}
