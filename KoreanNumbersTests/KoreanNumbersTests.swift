import XCTest
@testable import KoreanNumbers
final class KoreanNumbersTests: XCTestCase {
    
    // MARK: - Sino-Korean Tests
    
    func testSinoKoreanSingleDigits() {
        let view = SinoKoreanView(sinoKoreanNumber: "0")
        XCTAssertEqual(view.convertNumber(number: "0"), "영")
        
        XCTAssertEqual(view.convertNumber(number: "1"), "일")
        XCTAssertEqual(view.convertNumber(number: "5"), "오")
        XCTAssertEqual(view.convertNumber(number: "9"), "구")
    }
    
    func testSinoKoreanTens() {
        let view = SinoKoreanView(sinoKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: "10"), "십")
        XCTAssertEqual(view.convertNumber(number: "11"), "십일")
        XCTAssertEqual(view.convertNumber(number: "20"), "이십")
        XCTAssertEqual(view.convertNumber(number: "99"), "구십구")
    }
    
    func testSinoKoreanHundreds() {
        let view = SinoKoreanView(sinoKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: "100"), "백")
        XCTAssertEqual(view.convertNumber(number: "101"), "백일")
        XCTAssertEqual(view.convertNumber(number: "110"), "백십")
        XCTAssertEqual(view.convertNumber(number: "999"), "구백구십구")
    }
    
    func testSinoKoreanThousands() {
        let view = SinoKoreanView(sinoKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: "1000"), "천")
        XCTAssertEqual(view.convertNumber(number: "1001"), "천일")
        XCTAssertEqual(view.convertNumber(number: "1111"), "천백십일")
        XCTAssertEqual(view.convertNumber(number: "9999"), "구천구백구십구")
    }
    
    func testSinoKoreanTenThousands() {
        let view = SinoKoreanView(sinoKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: "10000"), "만")
        XCTAssertEqual(view.convertNumber(number: "10001"), "만 일")
        XCTAssertEqual(view.convertNumber(number: "12345"), "만 이천삼백사십오")
        XCTAssertEqual(view.convertNumber(number: "99999"), "만 구천구백구십구")
    }
    
    func testSinoKoreanEdgeCases() {
        let view = SinoKoreanView(sinoKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: ""), "영") // Empty string
        XCTAssertEqual(view.convertNumber(number: "000"), "영") // Multiple zeros
        XCTAssertEqual(view.convertNumber(number: "010"), "십") // Leading zero
    }
    
    // MARK: - Native-Korean Tests
    
    func testNativeKoreanSingleDigits() {
        let view = NativeKoreanView(nativeKoreanNumber: "0")
        XCTAssertEqual(view.convertNumber(number: "0"), "공")
        
        XCTAssertEqual(view.convertNumber(number: "1"), "하나")
        XCTAssertEqual(view.convertNumber(number: "5"), "다섯")
        XCTAssertEqual(view.convertNumber(number: "9"), "아홉")
    }
    
    func testNativeKoreanTens() {
        let view = NativeKoreanView(nativeKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: "10"), "열")
        XCTAssertEqual(view.convertNumber(number: "11"), "열하나")
        XCTAssertEqual(view.convertNumber(number: "20"), "스물")
        XCTAssertEqual(view.convertNumber(number: "21"), "스물하나")
        XCTAssertEqual(view.convertNumber(number: "99"), "아흔아홉")
    }
    
    func testNativeKoreanEdgeCases() {
        let view = NativeKoreanView(nativeKoreanNumber: "")
        XCTAssertEqual(view.convertNumber(number: ""), "공") // Empty string
        XCTAssertEqual(view.convertNumber(number: "000"), "공") // Multiple zeros
        XCTAssertEqual(view.convertNumber(number: "010"), "열") // Leading zero
        XCTAssertEqual(view.convertNumber(number: "100"), "공") // Beyond 99 should return "공" or handle differently
    }
    
    // MARK: - ContentView Tests
    
    func testNumberGeneration() {
        let contentView = ContentView()
        
        // Test Native-Korean range
        contentView.numberType = "Native-Korean"
        contentView.minNumber = 1
        contentView.maxNumber = 99
        let nativeNumber = contentView.generateNumber()
        XCTAssert((1...99).contains(Int(nativeNumber) ?? 0))
        
        // Test Sino-Korean range
        contentView.numberType = "Sino-Korean"
        contentView.minNumber = 0
        contentView.maxNumber = 9999
        let sinoNumber = contentView.generateNumber()
        XCTAssert((0...9999).contains(Int(sinoNumber) ?? -1))
    }
    
    func testRangeValidation() {
        let contentView = ContentView()
        
        // Valid range
        contentView.minNumber = 10
        contentView.maxNumber = 20
        XCTAssertTrue(contentView.coherentRange(min: contentView.minNumber, max: contentView.maxNumber))
        
        // Invalid range
        contentView.minNumber = 20
        contentView.maxNumber = 10
        XCTAssertFalse(contentView.coherentRange(min: contentView.minNumber, max: contentView.maxNumber))
    }
}
