import XCTest
@testable import Grados

class WeatherbitDataTests: XCTestCase {

  // MARK: - System Under Test
  var weatherSUT: WeatherbitData!
  
  // MARK: - Properties
  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
  }()
  var exampleJSONData: Data!
  
  // MARK: - Life cycle
  
  override func setUp() {
    super.setUp()
    
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "WeatherbitExample", withExtension: "json")!
    exampleJSONData = try! Data(contentsOf: url)
  
    let decoder = JSONDecoder()
    weatherSUT = try! decoder.decode(WeatherbitData.self, from: exampleJSONData)
    
  }
  
  override func tearDown() {
    weatherSUT = nil
    super.tearDown()
  }
  
  // MARK: - Tests
 
  func testDecodeTemp()        throws { XCTAssertEqual(weatherSUT.currentTemp                          , 24.19          ) }
  func testDecodeIcon()        throws { XCTAssertEqual(weatherSUT.iconName                             , "c03d"         ) }
  func testDecodeDescription() throws { XCTAssertEqual(weatherSUT.description                          , "Broken clouds") }
  func testDecodeDate()        throws { XCTAssertEqual(Self.dateFormatter.string(from: weatherSUT.date), "08-28-2017"   ) }

}
