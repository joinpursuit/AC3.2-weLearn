//
//  AchievementTableViewCell.swift
//  weLearn
//
//  Created by Marty Avedon on 3/8/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import SnapKit

// *** This is a container for the achievements -- see the collection view for cell details 

class AchievementTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var achievements = [Achievement]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupConstraints()
        
       collectionView.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "AchievementCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupHierarchy() {
        self.contentView.addSubview(box)
        self.contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { view in
            view.height.equalTo(100)
            view.width.equalToSuperview()
        }
        
        box.snp.makeConstraints { (view) in
            view.leading.equalTo(contentView).offset(7)
            view.top.equalTo(contentView).offset(7)
            view.trailing.equalTo(contentView).inset(7)
            view.bottom.equalTo(contentView).inset(7)
        }
        
        collectionView.snp.makeConstraints { view in
            view.top.leading.equalTo(box)
            view.bottom.trailing.equalTo(box)
        }
    }
    
    //MARK: - Collection View Data Source Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AchievementCollectionViewCell
        
        cell.achievementPic.image = UIImage(named: achievements[indexPath.row].pic)
        cell.descriptionLabel.text = achievements[indexPath.row].description
        
        return cell
    }
    
    lazy var box: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -2, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        return view
    }()
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
}
