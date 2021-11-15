import XCTest
@testable import Grados

class WeatherViewModelTests: XCTestCase {
  
  // MARK: - System Under Test
  var viewModelSUT: WeatherViewModel!
  
  // MARK: - Life cycle
  
  override func setUp() {
    super.setUp()
    viewModelSUT = WeatherViewModel()
  }
  
  override func tearDown() {
    viewModelSUT = nil
    super.tearDown()
  }
  
  // MARK: - Tests

  func testChangeLocationUpdatesLocationName() {
    
    // GIVEN
    
    // The locationName binding is asynchronous.
    // Use an expectation to wait for the asynchronous event.
    let expectation = self.expectation(description: "Find location using geocoder")
 
    // WHEN
    
    // Bind to locationName and only fulfill the expectation if the value matches the expected result.
    // Ignore any location name values such as “Loading…” or the default address.
    // Only the expected result should fulfill the test expectation.
    viewModelSUT.locationName.bind {
      if $0.caseInsensitiveCompare("Richmond, VA") == .orderedSame { expectation.fulfill() }
    }
    
    // THEN
    
    // Begin the test by changing the location.
    // It’s important to wait a few seconds before making the change so that any pending geocoding activity completes first.
    // When the app launches, it triggers a geocoder lookup.
    //
    // When it creates the test instance of the view model, it also triggers a geocoder lookup.
    // Waiting a few seconds allows those other lookups to complete before triggering the test lookup.
    //
    // Apple’s documentation explicitly warns that CLLocation can throw an error if the rate of requests is too high.
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.viewModelSUT.changeLocation(to: "Richmond, VA") }

    // Wait for up to eight seconds for the expectation to fulfill.
    // The test only succeeds if the expected result arrives before the timeout.
    waitForExpectations(timeout: 8, handler: nil)
    
  }
  
}
