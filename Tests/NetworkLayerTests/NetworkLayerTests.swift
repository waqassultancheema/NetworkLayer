import XCTest
@testable import NetworkLayer

final class ServiceApiTests: XCTestCase {
    //
    // MARK:- Subject under testing
    var sut: WebAPIProtocol!
    //
    //
    // MARK:- OverRide Methods
    override func setUp() {
        super.setUp()
    }
    //
    //
    // MARK:- Test Methods
    func testServiceNoInternetError() {
        let session =  StubURLSession()
        session.nextData = nil
        sut = ServiceApi(session: session)
        session.nextResponse = HTTPURLResponse(url: URL(string: "http://www.google.com")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        sut.requestData(apiRequest: APIRequest(host: "www.google.com", path: "")) { (response, error) in
            if let err = error {
                XCTAssertNotNil(err.localizedDescription)
            } else {
               XCTFail()
            }
        }
    }
    func testShouldReturnCorrectResult() {
        let session =  StubURLSession()
        session.nextData = "{}".data(using: .utf8)
        sut = ServiceApi(session: session)
        session.nextResponse = HTTPURLResponse(url: URL(string: "http://www.google.com")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        sut.requestData(apiRequest: APIRequest(host: "www.google.com", path: "")) { (response, error) in
            XCTAssertNil(error)
        }
    }
}
