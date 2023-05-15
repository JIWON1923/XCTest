//
//  CarouselCollectionViewCell.swift
//  TravelApp
//
//  Created by 이지원 on 2023/05/14.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func configure(with city: City) {
        imageView.image = city.image
    }
}
