//
//  SDWebImageViewController.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 21/08/2022.
//

import UIKit
import SnapKit
import SDWebImage

final class SDWebImageViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("----------------------SDWebImage---------------------------")
        // remove All Cache
//        SDWebImageManager.shared.imageCache.clear(with: .all) {
//            print("clear all cache")
//        }
    }
    
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func printCacheSize() {
//        print("disk Cache Count: \(SDImageCache.shared.diskCache.totalCount())")
//        print("disk Cache Size: \(SDImageCache.shared.diskCache.totalSize() / 1024) KB")
//        print(SDImageCache.shared.memoryCache)
    }
    
    private func printCachedDirectory() {
        let fileManager = FileManager.default
        let documentPath: URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        print(documentPath)
    }
}


extension SDWebImageViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id,
                                                            for: indexPath) as? CustomCollectionViewCell
        else { return UICollectionViewCell() }
        
        let url = URL(string: data[indexPath.row])
        
        cell.imageView.sd_setImage(with: url) { image, _, cachetype, _ in
            print(image)
        }
        return cell
    }
}
