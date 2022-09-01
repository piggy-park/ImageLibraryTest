//
//  NukeViewController.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 21/08/2022.
//

import UIKit
import Nuke
import Kingfisher

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
        
        self.collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.id)
        setLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("----------------------Nuke---------------------------")
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension NukeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id,
                                                            for: indexPath) as? CustomCollectionViewCell
        else { return UICollectionViewCell() }
        print(ImageCache.defaultCostLimit())
        
        let url = URL(string: data[indexPath.row])
        
        Nuke.loadImage(with: url!, into: cell.imageView) { result in
            print(result.map({ result in
//                result.urlResponse
                result.container
            }))
        }
        return cell
    }
}

extension NukeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        <#code#>
    }
    
    func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
    ) {
        let imageUrl = URL(string:data[indexPath.row])!
    if let cell = cell as? CustomCollectionViewCell {
        Nuke.loadImage(with: imageUrl, into: cell.imageView) { result in
            print("\(indexPath.row) \(result)")
        }
        }
    }
}
