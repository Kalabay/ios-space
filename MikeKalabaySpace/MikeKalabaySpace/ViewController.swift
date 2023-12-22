//
//  ViewController.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var blogs = [Blog]()
    private var articles = [Article]()
    private var allArticles = [Article]()
    private var isLoadingBlogs = false
    private var isLoadingArticles = false
    private var nextBlogPage: String?
    private var nextArticlePage: String?
    private var blogCollectionView: UICollectionView!
    private var articleCollectionView: UICollectionView!
    private var selectedBlog: Blog?
    let topPadding: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupCollectionView()
        fetchBlogs()
        fetchArticles()
    }
    
    private func filterArticlesBySelectedBlog() {
        if let selectedBlog = selectedBlog {
            let filteredArticles = allArticles.filter { $0.news_site == selectedBlog.news_site }
            print("Дебаг вывод персечения: \(filteredArticles.count)")
            articles = filteredArticles
        } else {
            articles = allArticles
        }
        articleCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == blogCollectionView {
            let selectedBlog = blogs[indexPath.item]
            self.selectedBlog = selectedBlog
            filterArticlesBySelectedBlog()
        }
    }
    
    private func fetchBlogs() {
        guard !isLoadingBlogs else { return }
        isLoadingBlogs = true
        let urlString = nextBlogPage ?? "https://api.spaceflightnewsapi.net/v4/blogs"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let blogResponse = try? JSONDecoder().decode(BlogResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.isLoadingBlogs = false
                        self.blogs += blogResponse.results
                        self.nextBlogPage = blogResponse.next
                        self.blogCollectionView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    
    private func fetchArticles() {
        guard !isLoadingArticles else { return }
        isLoadingArticles = true
        let urlString = nextArticlePage ?? "https://api.spaceflightnewsapi.net/v4/articles"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let articleResponse = try? JSONDecoder().decode(ArticleResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.isLoadingArticles = false
                        self.articles += articleResponse.results
                        self.allArticles = self.articles
                        self.nextArticlePage = articleResponse.next
                        self.articleCollectionView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setupCollectionView() {
        let topPadding: CGFloat = 50

        let blogLayout = UICollectionViewFlowLayout()
        blogLayout.scrollDirection = .horizontal
        blogLayout.minimumLineSpacing = 10
        blogLayout.minimumInteritemSpacing = 10
        blogCollectionView = UICollectionView(frame: CGRect(x: 20, y: 20 + topPadding, width: view.bounds.width - 40, height: view.bounds.height / 3), collectionViewLayout: blogLayout)
        
        blogCollectionView.backgroundColor = .systemPink
        blogCollectionView.translatesAutoresizingMaskIntoConstraints = false
        blogCollectionView.delegate = self
        blogCollectionView.dataSource = self
        blogCollectionView.register(BlogCollectionViewCell.self, forCellWithReuseIdentifier: "BlogCollectionViewCell")

        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.scrollDirection = .vertical
        articleLayout.minimumLineSpacing = 20
        articleLayout.minimumInteritemSpacing = 10
        articleCollectionView = UICollectionView(frame: CGRect(x: 20, y: (view.bounds.height / 3) + 40 + topPadding, width: view.bounds.width - 40, height: (view.bounds.height * 2 / 3) - 60), collectionViewLayout: articleLayout)
        
        articleCollectionView.backgroundColor = .red
        articleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: "ArticleCollectionViewCell")

        view.addSubview(blogCollectionView)
        view.addSubview(articleCollectionView)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == blogCollectionView {
            return blogs.count
        }
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == blogCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCollectionViewCell", for: indexPath) as! BlogCollectionViewCell
            let blog = blogs[indexPath.item]
            cell.configure(with: blog)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
            let article = articles[indexPath.item]
            cell.configure(with: article)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == blogCollectionView {
            let height: CGFloat = collectionView.bounds.height
            let width: CGFloat = collectionView.bounds.width / 2
            return CGSize(width: width, height: height)
        } else {
            let width: CGFloat = collectionView.bounds.width
            let height: CGFloat = collectionView.bounds.height / 3
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == blogCollectionView {
            if indexPath.item == blogs.count - 5 {
                fetchBlogs()
            }
        } else {
            if indexPath.item == articles.count - 5 {
                fetchArticles()
            }
        }
    }
}

