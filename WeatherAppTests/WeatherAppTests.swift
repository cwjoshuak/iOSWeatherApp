//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Joshua Kuan on 5/6/22.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    var weatherVM: WeatherViewModel?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherVM = WeatherViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherVM = nil
    }

    func testFetchData() throws {
        let expectation = expectation(description: "fetchWeather")
        weatherVM?.fetchData(lat: 37.7873589, long: -122.408227) { [weak self] success in
            XCTAssertNotNil(self?.weatherVM?.daily)
            XCTAssertNotNil(self?.weatherVM?.hourly)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
