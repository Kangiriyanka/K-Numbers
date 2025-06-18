import XCTest
@testable import KoreanNumbers

final class KoreanNumbersTests: XCTestCase {

    // --- Sino-Korean Tests ---
    func testConvertSinoKoreanNumberSingleDigit() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "1").convertNumber(), "일")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "0").convertNumber(), "영")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "9").convertNumber(), "구")
    }

    func testConvertSinoKoreanNumberTens() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "10").convertNumber(), "십")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "11").convertNumber(), "십일")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "21").convertNumber(), "이십일")
    }

    func testConvertSinoKoreanNumberHundreds() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "100").convertNumber(), "백")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "105").convertNumber(), "백오")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "210").convertNumber(), "이백십")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "999").convertNumber(), "구백구십구")
    }

    func testConvertSinoKoreanNumberThousands() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "1000").convertNumber(), "천")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "4321").convertNumber(), "사천삼백이십일")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "2001").convertNumber(), "이천일")
    }

    func testConvertSinoKoreanNumberTenThousands() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "10000").convertNumber(), "일만 ")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "43934").convertNumber(), "사만 삼천구백삼십사")
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "99999").convertNumber(), "구만 구천구백구십구")
    }

    func testConvertSinoKoreanEdgeCases() {
        XCTAssertEqual(SinoKoreanConverter(sinoKoreanNumber: "0001").convertNumber(), "일") //
      
    }

    // --- Native Korean Tests ---
    func testConvertNativeKoreanNumberSingleDigit() {
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "0").convertNumber(), "공")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "1").convertNumber(), "하나")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "2").convertNumber(), "둘")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "9").convertNumber(), "아홉")
    }

    func testConvertNativeKoreanNumberTens() {
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "10").convertNumber(), "열")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "15").convertNumber(), "열다섯")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "20").convertNumber(), "스물")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "27").convertNumber(), "스물일곱")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "43").convertNumber(), "마흔셋")
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "99").convertNumber(), "아흔아홉")
    }

    func testConvertNativeKoreanEdgeCases() {
    
        XCTAssertEqual(NativeKoreanConverter(nativeKoreanNumber: "07").convertNumber(), "일곱")
    }
}
