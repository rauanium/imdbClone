//
//  MovieTableViewCell.swift
//  imdb
//
//  Created by rauan on 12/2/23.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    var moviePoster: UIImageView = {
        let moviePoster = UIImageView()
        moviePoster.layer.cornerRadius = 10
        moviePoster.layer.masksToBounds = true
        return moviePoster
    }()
    
    var movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.numberOfLines = 0
        movieTitle.textAlignment = .center
        movieTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return movieTitle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "movieCell")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.contentView.addSubview(moviePoster)
        self.contentView.addSubview(movieTitle)
        selectionStyle = .none
        backgroundColor = .clear
        
        moviePoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(560)
        }
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            make.centerX.equalTo(moviePoster.snp.centerX)
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(contentView.snp.width)
        }
    }
    
    func configure(with title: String, and imagePath: String){
        movieTitle.text = title
        let urlString = "https://image.tmdb.org/t/p/w200\(imagePath)"
        let url = URL(string: urlString)!
        moviePoster.kf.setImage(with: url)
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    self.moviePoster.image = UIImage(data: data)
//                }
//            }
//        }
      }
}



