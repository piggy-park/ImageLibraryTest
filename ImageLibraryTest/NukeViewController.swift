//
//  NukeViewController.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 21/08/2022.
//

import UIKit
import Nuke

class NukeViewController: UIViewController {
    
    var data: [String] = MockData.mockData
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printCachedDirectory()
        
        self.collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.id)
        setLayout()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("")
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func printCacheSize() {
        
    }
    
    private func printCachedDirectory() {
        let fileManager = FileManager.default
        let documentPath: URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        print(documentPath)
    }
}


extension NukeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id,
                                                            for: indexPath) as? CustomCollectionViewCell
        else { return UICollectionViewCell() }
        
        let url = URL(string: data[indexPath.row])
        Nuke.loadImage(with: url!, into: cell.imageView)
        return cell
    }
}


