//
//  ViewController.swift
//  Argh!
//
//  Created by Tobin Schwaiger-Hastanan on 2/7/19.
//  Copyright © 2019 Tobin Schwaiger-Hastanan. All rights reserved.
//

import UIKit

class CollectionViewCell:UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data:String) {
        
    }
}

class ViewController: UIViewController {

    var data:[[String]] = []
    
    var less:[[String]] = [
        ["one", "two", "three"]
    ]

    var more:[[String]] = [
        ["a", "b", "c"],
        ["one", "two", "three"]
    ]

    lazy var collectionsViewLayout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        return layout
    }()

    lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionsViewLayout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.isPrefetchingEnabled = false
        collectionView.prefetchDataSource = nil
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        return collectionView
    }()
    
    lazy var collectionViewHeight:NSLayoutConstraint = {
        return self.collectionView.heightAnchor.constraint(equalToConstant: 44)
    }()
    
    lazy var button:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.setTitle("Argh!", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(self.toggle(_:)), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            self.button.heightAnchor.constraint(equalToConstant: 44),
            self.button.widthAnchor.constraint(equalToConstant: 100),
            self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.collectionViewHeight,
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        self.data = self.more
        self.collectionView.reloadData()
    }

    @objc func toggle(_ sender:AnyObject) {
        if self.collectionViewHeight.constant == 44 {
            self.collectionViewHeight.constant = 0
        } else {
            self.data = self.less
            self.collectionView.reloadData()
            self.collectionViewHeight.constant = 44
        }
    }

}


extension ViewController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let array = self.data[indexPath.section]
        let data = array[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        
        if let cell = cell as? CollectionViewCell {
            cell.configure(data: data)
        }
        
        return cell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionViewLayout is UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 64, height: 40)
    }
}
