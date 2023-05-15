//
//  DistanceCalculatorTests.swift
//  TravelAppTests
//
//  Created by 이지원 on 2023/05/15.
//

import XCTest
@testable import TravelApp

final class DistanceCalculatorTests: XCTestCase {
    
    var calculator: DistancaCaculator!
    
    override func setUp() {
        calculator = DistancaCaculator()
        super.setUp()
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    // 1. city function이 제대로 동작하는지 확인하기
    func testCoordinatesOfNewYork() throws {
        
        // 1) 객체 생성
//        let calculator = DistancaCaculator()
        
        // 2) 테스트하고자하는 city 함수 호출해야함.
        // 이슈 1 : city는 Optional을 리턴함. 하지만 여기선 not nil을 기준으로 test 필요. 따라서 XCTUnwrap 이용
        // 이슈 2 : city함수가 Error를 뱉지만, 그것에 대한 핸들을 따로 해주지 않음 -> 함수에 throws 추가
        let city = try XCTUnwrap(calculator.city(forName: "NewYork"))
        
        XCTAssertEqual(city.coordinates.latitude, 40.7128)
        XCTAssertEqual(city.coordinates.longitude, -74.0060)
    }
    
    
    // 2. 도시 간 거리 측정하는 함수 테스트 - distance return 하는 함수
    func testParisToNewYork() throws {
        // 1) test를 실행할 때마다 Caculator 객체가 생성되는 것을 방지하기 위해 setUp에서 객체를 생성한다. (13, 16번째 줄)
        
        // 2) 두 도시 사이 거리를 계산한다.
        let distanceInMiles = try calculator.distanceInMiles(from: "Paris", to: "NewYork")
        
        // 3) Equal은 아주 정확한 값을 비교해서, 원하는 테스트를 만들어내지 못함
//        XCTAssertEqual(distanceInMiles, 3636)
        
        // 4) accuracy를 이용해서 해결 - accuracy는 1만큼 오차를 허용한다는 의미
        XCTAssertEqual(distanceInMiles, 3636, accuracy: 1)
    }
    
    // 3. 에러를 제대로 뱉어내는지 테스트
    func testCupertinoNotRecognized() {
        XCTAssertThrowsError(try calculator.distanceInMiles(from: "Cupertino", to: "NewYork")) { error in
            XCTAssertEqual(error as? DistancaCaculator.Error, .unknownCity("Cupertino"))
        }
    }
}
