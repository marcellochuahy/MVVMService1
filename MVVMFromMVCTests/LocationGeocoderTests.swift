import XCTest
@testable import Grados

class LocationGeocoderTests: XCTestCase {
  
  // MARK: - System Under Test
  var geocoderSUT: LocationGeocoder!
  
  // MARK: - Life cycle
  
  override func setUp() {
    super.setUp()
    geocoderSUT = LocationGeocoder()
  }
  
  override func tearDown() {
    geocoderSUT = nil
    super.tearDown()
  }
  
  // MARK: - Tests
 
  func testGeocodingRazewareHeadquarters() {
    
    let expectation = self.expectation(description: "Geocoding Results")

    geocoderSUT.geocode(addressString: "McGaheysville, VA") { (locations: [Location])  in
      print(locations)
      XCTAssertEqual(locations.count, 1)
      XCTAssertEqual(locations.first!.name, "McGaheysville, VA")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
    
  }
  
}
