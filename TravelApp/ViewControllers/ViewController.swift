//
//  ViewController.swift
//  TravelApp
//
//  Created by 이지원 on 2023/05/14.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityCollectionView: UICollectionView! {
        didSet {
            cityCollectionView.delegate = self
            cityCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    private let locationManager = CLLocationManager()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    
    private let cities = [
        City(name: "New York", image: UIImage(named: "newyork")!, latitude: 40.7128, longitude: -74.0060),
        City(name: "Paris", image: UIImage(named: "paris")!, latitude: 48.8566, longitude: 2.3522),
        City(name: "Tokyo", image: UIImage(named: "tokyo")!,  latitude: 35.5896, longitude: 139.6917),
        City(name: "London", image: UIImage(named: "london")!,  latitude: 51.5074, longitude: -0.1278),
        City(name: "Sydney", image: UIImage(named: "sydney")!,  latitude: -33.8651, longitude: 151.2099)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupCollectionView()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func setupCollectionView() {
        cityCollectionView.collectionViewLayout = collectionViewFlowLayout
        cityCollectionView.isPagingEnabled = true
        cityCollectionView.showsHorizontalScrollIndicator = false
    }
}


// MARK: - CoreLocation
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func calculateDistance(userLatitude: Double, userLongitude: Double, cityLatitude: Double, cityLongitude: Double) -> Double {
        let earthRadius: Double = 6371 // 지구 반지름 (단위: km)
        
        // 각도를 라디안으로 변환
        let lat1Rad = userLatitude.toRadians()
        let lon1Rad = userLongitude.toRadians()
        let lat2Rad = cityLatitude.toRadians()
        let lon2Rad = cityLongitude.toRadians()
        
        // 위도 및 경도의 차이 계산
        let deltaLat = lat2Rad - lat1Rad
        let deltaLon = lon2Rad - lon1Rad
        
        // Haversine 공식 적용
        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c
        
        return distance
    }
}

// MARK: - Carousel CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as? CarouselCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cities[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth * 0.8 // 원하는 크기 비율로 조정
        let cellHeight = collectionView.bounds.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth * 0.8 // 셀의 가로 크기
        let sideInset = (collectionViewWidth - cellWidth) / 2.0 // 좌우 여백
        
        return sideInset * 2 // 셀 사이의 간격을 좌우 여백의 2배로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth * 0.8 // 셀의 가로 크기
        let sideInset = (collectionViewWidth - cellWidth) / 2.0 // 좌우 여백
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
        let currentPage = targetContentOffset.pointee.x / pageWidth

        var nextPage: CGFloat
        if velocity.x > 0 {
            nextPage = ceil(currentPage)
        } else if velocity.x < 0 {
            nextPage = floor(currentPage)
        } else {
            nextPage = round(currentPage)
        }

        let offsetX = nextPage * pageWidth
        targetContentOffset.pointee = CGPoint(x: offsetX, y: targetContentOffset.pointee.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateData()
    }

    private func updateData() {
        let centerPoint = CGPoint(x: cityCollectionView.contentOffset.x + cityCollectionView.bounds.width / 2, y: cityCollectionView.bounds.height / 2)
        
        if let indexPath = cityCollectionView.indexPathForItem(at: centerPoint) {
            let currentIndex = indexPath.item
            let city = cities[currentIndex]
            cityName.text = city.name
            distance.text = String(calculateDistance(userLatitude: latitude, userLongitude: longitude, cityLatitude: city.latitude, cityLongitude: city.longitude))
            // 레이블 업데이트
            
        }
    }
}
