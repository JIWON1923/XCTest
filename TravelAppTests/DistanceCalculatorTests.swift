//
//  DistanceCalculatorTests.swift
//  TravelAppTests
//
//  Created by 이지원 on 2023/05/15.
//

import XCTest
@testable import TravelApp

final class DistanceCalculatorTests: XCTestCase {
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
    // 1. city function이 제대로 동작하는지 확인하기
    func testCoordinatesOfNewYork() throws {
        
        // 1) 객체 생성
        let calculator = DistancaCaculator()
        
        // 2) 테스트하고자하는 city 함수 호출해야함.
        // 이슈 1 : city는 Optional을 리턴함. 하지만 여기선 not nil을 기준으로 test 필요. 따라서 XCTUnwrap 이용
        // 이슈 2 : city함수가 Error를 뱉지만, 그것에 대한 핸들을 따로 해주지 않음 -> 함수에 throws 추가
        let city = try XCTUnwrap(calculator.city(forName: "NewYork"))
        
        XCTAssertEqual(city.coordinates.latitude, 40.7128)
        XCTAssertEqual(city.coordinates.longitude, -74.0060)
    }
}
