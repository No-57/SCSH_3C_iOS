//
//  BoardCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/22.
//

import UIKit
import Kingfisher

class BoardCollectionViewCell: UICollectionViewCell {
    
    private var baord: ExploreBoard = ExploreBoard(id: UUID().uuidString, imageUrl: nil, actionType: nil, action: nil)
    
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(board: ExploreBoard) {
        imageView.kf.setImage(with: board.imageUrl, placeholder: UIImage(systemName: "photo.fill"))
        baord = board
    }
    
    func getBoard() -> ExploreBoard {
        baord
    }
}
