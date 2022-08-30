//
//  RootViewController.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 22/08/2022.
//

import SnapKit
import UIKit
import Kingfisher
import SDWebImage
import Nuke

final class RootViewController: UIViewController {
    let kingfisher = KingFisherViewController()
    let nuke = NukeViewController()
    let sdwebImage = SDWebImageViewController()
    let noLibrary = NoLibraryViewController()
    
    let noLibraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("NoLibrary", for: .normal)
        return button
    }()
    
    let kingfisherButton: UIButton = {
        let button = UIButton()
        button.setTitle("KingFisher", for: .normal)
        return button
    }()
    
    let nukeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Nuke", for: .normal)
        return button
    }()
    
    let sdWebImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("SDWebImage", for: .normal)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return  stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction()
        setButton()
        printCachedDirectory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // remove All Cache
//        SDImageCache.shared.clearMemory()
//        SDImageCache.shared.clearDisk()
//
//        KingfisherManager.shared.cache.clearCache()
//
//        Nuke.ImageCache.shared.removeAll()
//
//        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
////
//        ImageCacheManger.shared.removeAllObjects()
//
    }
    
    private func printCachedDirectory() {
        let fileManager = FileManager.default
        let documentPath: URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        print(documentPath)
    }
    
    
    private func addAction() {
        
        let goToKingfisherAction = UIAction { [weak self] _ in
            self!.navigationController?.pushViewController(self!.kingfisher, animated: true)
        }
        let goToNukeAction = UIAction { [weak self] _ in
            self!.navigationController?.pushViewController(self!.nuke, animated: true)
        }
        let goToSDWebAction = UIAction { [weak self] _ in
            self!.navigationController?.pushViewController(self!.sdwebImage, animated: true)
        }
        let goToNoLibrary = UIAction { [weak self] _ in
            self!.navigationController?.pushViewController(self!.noLibrary, animated: true)
        }
        self.kingfisherButton.addAction(goToKingfisherAction, for: .touchUpInside)
        self.nukeButton.addAction(goToNukeAction, for: .touchUpInside)
        self.sdWebImageButton.addAction(goToSDWebAction, for: .touchUpInside)
        self.noLibraryButton.addAction(goToNoLibrary, for: .touchUpInside)
    }
    
    
    private func setButton() {
        [noLibraryButton, kingfisherButton, nukeButton, sdWebImageButton].forEach{
            self.buttonStackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
}
