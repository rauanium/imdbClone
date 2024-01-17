//
//  FavoriteViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import SnapKit
import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    private lazy var favoriteMovies: [NSManagedObject] = []{
        didSet {
            self.movieTableView.reloadData()
        }
    }
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Favorite"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private lazy var movieTableView: UITableView = {
        let movieTableView = UITableView()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        movieTableView.separatorStyle = .none
        movieTableView.showsVerticalScrollIndicator = false
        return movieTableView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    //MARK: - Methods
    private func loadMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        
        do {
            favoriteMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. Error: \(error)")
        }
    }
}
    
    //MARK: - Constraints
    extension FavoriteViewController {
        private func setupViews(){
            view.backgroundColor = .white
            
            [titleLabel, movieTableView].forEach {
                view.addSubview($0)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
            }
            
            movieTableView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.right.left.bottom.equalToSuperview()
            }
        }
    }

    
    //MARK: - TableViewDelegate section
    extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteMovies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
            let movie = favoriteMovies[indexPath.row]
            let title = movie.value(forKeyPath: "title") as? String
            let posterPath = movie.value(forKeyPath: "posterPath") as? String
            cell.configure(with: title ?? "", and: posterPath ?? "")
            
            let isFavoriteMovie = !self.favoriteMovies.filter({
                ($0.value(forKeyPath: "id") as? Int) == movie.value(forKeyPath: "id") as? Int }).isEmpty
            cell.toggleFavoriteIcon(with: isFavoriteMovie)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let movieDetailViewController = MovieDetailsViewController()
            let movie = favoriteMovies[indexPath.row]
            let id = movie.value(forKeyPath: "id") as? Int
            movieDetailViewController.movieId = id ?? 0
            navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }

