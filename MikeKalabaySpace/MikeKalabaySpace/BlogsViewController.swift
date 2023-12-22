//
//  BlogsViewController.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import Foundation
import UIKit

class BlogsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return blogs.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCollectionViewCell", for: indexPath) as! BlogCollectionViewCell
        cell.configure(with: blogs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == blogs.count - 1, !isLoading {
                currentPage += 1
                loadBlogs()
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var blogs: [Blog] = []
    var currentPage = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadBlogs()
    }
    
    func loadBlogs() {
        isLoading = true
        let urlString = "https://api.spaceflightnewsapi.net/v4/blogs/?limit=10&page=\(currentPage)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data")
                self?.isLoading = false
                return
            }
            
            do {
                let blogsResponse = try JSONDecoder().decode(BlogResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.blogs.append(contentsOf: blogsResponse.results)
                    self?.collectionView.reloadData()
                    self?.isLoading = false
                }
            } catch let decodingError {
                print("Error decoding data: \(decodingError)")
                self?.isLoading = false
            }
        }
        
        task.resume()
    }
}
