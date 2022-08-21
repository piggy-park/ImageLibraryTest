//
//  CollectionViewCell.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 21/08/2022.
//

import UIKit
import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    static let id = "CustomCell"
    
    let imageView: UIImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
