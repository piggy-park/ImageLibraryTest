//
//  NoLibraryViewController.swift
//  ImageLibraryTest
//
//  Created by 박진섭 on 29/08/2022.
//

import UIKit
import SnapKit

class NoLibraryViewController: UIViewController {

    let imageManager = ImageManager()

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
        print("----------------------NO Library---------------------------")
    }


    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            }
        }
}


extension NoLibraryViewController: UICollectionViewDataSource {

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id,
                                                        for: indexPath) as? CustomCollectionViewCell
    else { return UICollectionViewCell() }

    imageManager.loadimage(imageView: cell.imageView, urlString: data[indexPath.row], number: indexPath.row)

    return cell
    }
}



//imageCache를 담당할 싱글톤 클래스
class ImageCacheManger {
    static var shared = NSCache<NSString,UIImage>() //memory
    static func removeMemoryCache() {
        shared = NSCache<NSString, UIImage>()
    }
    private init() { }
}

class ImageManager: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var cacheKeys = [URL]()

    // Disk Cache 다 지움 - 예정
    func removeDiskCache() {
        self.cacheKeys.forEach { url in
            try? FileManager.default.removeItem(atPath: url.path)
        }
    }

    func loadimage(imageView: UIImageView, urlString: String, number: Int) {
        let fileManager = FileManager.default

        guard let imageURL = URL(string: urlString) else { return }
        //URL의 마지막 Path Component로 Key를 만듬.
        let cacheKey = NSString(string: imageURL.lastPathComponent)

        //1. Cache에 이미 image가 있다면 image를 가져와서 넣고 함수를 종료함. (Memory Cache확인)
        //2. Memory Cache에 없다 -> diskCache를 찾아봄
        DispatchQueue.main.async {
            if let cachedImage = ImageCacheManger.shared.object(forKey: cacheKey) {
                imageView.image = cachedImage
                return
            }
        }
        //Cache가 저장되는 path(Disk Caching)
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
//            print("캐쉬가 저장되는 폴더 path(String): \(path)")

        var filePath = URL(fileURLWithPath: path)
//            print("폴더 Path에서 file을 찾을 수 있는 Path(URL): \(filePath)")

        cacheKeys.append(filePath)

        filePath.appendPathComponent(imageURL.lastPathComponent)
//            print("폴더 Path에서 특정 file을 찾기 위한 PathComponent을 붙임.\(filePath)")
//            print("다시 파일을 찾을때 fileManger에서 쓸 Path: \(filePath.path)")

        //disk에서 cache된 파일이 있다.
        //3. Cache된 데이터를 이용해서 이미지를 띄운다.
        //4. 다음을 위해서 memoryCache에 넣는다.
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath), //원격 서버 X , 내부파일
                  let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
            ImageCacheManger.shared.setObject(image, forKey: cacheKey)    //cacheKey로 image를 등록함.
            return
        }

        //disk에도 cache된 파일이 없다.
        //5. disk에 파일을 생성한다.
        //6. MemoryCache와 Disk 모두 없기 때문에 URL에서 비동기로 가지고 온다.
        //7. Memorycache와 Disk 모두 저장해둔다.
        URLSession.shared.dataTask(with: imageURL) {  data, _, _ in
            print("\(number)번째 이미지 크기: \(data!.count)byte")
            guard let imageData = data,
                  let image = UIImage(data: imageData) else { return }
            if !fileManager.fileExists(atPath: filePath.path) {
                fileManager.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
                ImageCacheManger.shared.setObject(image, forKey: cacheKey)    //cacheKey로 image를 등록함.
                DispatchQueue.main.async {
                    imageView.image = image
                    print(image)
                }
                return
            }
        }.resume()
    }
}
