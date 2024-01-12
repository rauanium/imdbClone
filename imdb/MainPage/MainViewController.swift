//
//  ViewController.swift
//  imdb
//
//  Created by rauan on 12/2/23.
//
import SnapKit
import UIKit

class MainViewController: UIViewController {
    private var titleLabelYPosition: Constraint!
    private var genreCollectionIsHidden = false
    private var currentStatus = "now_playing"
    private var networkManager = NetworkManager.shared
    private let movieStatus = ["Now Playing", "Upcoming", "Popular", "Top Rated"]
    private let themes = Themes.allCases
    
    private var allResults: [Result] = []
    private lazy var result: [Result] = []{
        didSet {
            self.movieTableView.reloadData()
        }
    }
    private lazy var movieGenres: [Genre] = [.init(id: 1, name: "All")]{
        didSet {
            self.genresCollectionView.reloadData()
        }
    }
    
    private let containerView = UIView()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MovieDB"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private let themeLabel: UILabel = {
        let themeLabel = UILabel()
        themeLabel.text = "Theme"
        themeLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return themeLabel
    }()
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
        }()
        
    private lazy var movieStatusCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieStatusCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var foldableStackView: UIStackView = {
        let foldableStackView = UIStackView()
        foldableStackView.axis = .vertical
        foldableStackView.distribution = .equalSpacing
        foldableStackView.spacing = 16
        foldableStackView.alignment = .leading
        return foldableStackView
    }()
    
    private lazy var arrowButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 24)
        configuration.attributedTitle = AttributedString("Genre", attributes: container)
        configuration.titleAlignment = .leading
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        configuration.image = UIImage(systemName: "chevron.right")
        
        var arrowButton = UIButton(configuration: configuration)
        arrowButton.tintColor = .black
        arrowButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        return arrowButton
    }()
    
    private lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieStatusCollectionViewCell.self, forCellWithReuseIdentifier: "genresCollection")
        return collectionView
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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViews()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        genresCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: [])
        movieStatusCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: [])
        animate()
    }
    
    private func loadData(){
        networkManager.loadGenres { [weak self] genres in
            genres.forEach { genre in
                self?.movieGenres.append(genre)
            }
        }
        networkManager.loadMovies(with: currentStatus) { [weak self] movies in
            self?.result = movies
            self?.allResults = movies
        }
    }
    
    private func obtainMovieList(with genreId: Int) {
        guard genreId != 1 else {
            result = allResults
            return
        }
        
        result = allResults.filter{ movie in
            movie.genreIDS.contains(genreId)
        }
    }
    
    @objc func imageTapped(){
        if genreCollectionIsHidden {
            genreCollectionIsHidden = false
            showGenreCollectionView()
            arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        }else{
            genreCollectionIsHidden = true
            hideGenreCollectionView()
            arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    
    //MARK: - animation
    private func animate(){
        UIView.animateKeyframes(withDuration: 3.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.titleLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.3) {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.05) {
                self.dampingEffect()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.91, relativeDuration: 0.5) {
                self.containerView.alpha = 1
            }
        }
    }
    private func dampingEffect(){
        UIView.animate(withDuration: 0.4, delay: 1.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7) {
            self.titleLabelYPosition.update(offset: -(self.view.safeAreaLayoutGuide.layoutFrame.size.height / 2 - 16))
            self.view.layoutSubviews()
        }
    }
    
    //MARK: - animation of folding genres collection view
    private func hideGenreCollectionView(){
        UIView.animateKeyframes(withDuration: 1, delay: 0){
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.25) {
                self.genresCollectionView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.1) {
                self.genresCollectionView.isHidden = true
            }
        }
    }
    private func showGenreCollectionView(){
        UIView.animateKeyframes(withDuration: 1, delay: 0){
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                self.genresCollectionView.isHidden = false
            }
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.4) {
                self.genresCollectionView.alpha = 1
            }
        }
    }
}

//MARK: - Contraints
extension MainViewController {
    private func setupViews(){
        view.backgroundColor = .white
        containerView.alpha = 0
        
        [titleLabel, containerView].forEach {
            view.addSubview($0)
        }
        foldableStackView.addArrangedSubview(arrowButton)
        foldableStackView.addArrangedSubview(genresCollectionView)
        
        [themeLabel, movieStatusCollectionView, movieTableView, foldableStackView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            titleLabelYPosition = make.centerY.equalToSuperview().constraint
            make.centerX.equalToSuperview()
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        movieStatusCollectionView.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.right.left.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        foldableStackView.snp.makeConstraints { make in
            make.top.equalTo(movieStatusCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints { make in
            make.top.equalTo(movieStatusCollectionView.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.height.equalTo(20)
        }
        
        genresCollectionView.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(foldableStackView.snp.bottom).offset(16)
            make.right.left.bottom.equalToSuperview()
        }
    }
}

//MARK: - TableViewDelegate section
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = result[indexPath.row]
        cell.configure(with: movie.title, and: movie.posterPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailsViewController()
        let movie = result[indexPath.row]
        movieDetailViewController.movieId = movie.id
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

//MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieStatusCollectionView{
            return themes.count
        }
        else {
            return movieGenres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieStatusCollectionView {
            let cell = movieStatusCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MovieStatusCollectionViewCell
            cell.configure(with: themes[indexPath.row].key)
            return cell
        }
        else {
            let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: "genresCollection", for: indexPath) as! MovieStatusCollectionViewCell
            cell.configure(with: movieGenres[indexPath.row].name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if collectionView == movieStatusCollectionView {
            if indexPath.row == 0 {
                currentStatus = themes[indexPath.row].urlPath
                loadData()
            }
            else if indexPath.row == 1 {
                currentStatus = themes[indexPath.row].urlPath
                loadData()
            }
            else if indexPath.row == 2 {
                currentStatus = themes[indexPath.row].urlPath
                loadData()
            }
            else if indexPath.row == 3 {
                currentStatus = themes[indexPath.row].urlPath
                loadData()
            }
        }
        else {
            print(movieGenres[indexPath.row].id)
            obtainMovieList(with: movieGenres[indexPath.row].id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView{
            CGSize(width: 140, height: collectionView.frame.height)
        }
        else {
            CGSize(width: 140, height: collectionView.frame.height)
        }
    }
}


