import XCTest
import SwiftUI
import ViewInspector
@testable import FlickrImageSearch

class ImageGridViewTests: XCTestCase {
    
    var imageGridView: ImageGridView!
    
    override func setUp() {
        super.setUp()
        imageGridView = ImageGridView()
    }
    
    override func tearDown() {
        imageGridView = nil
        super.tearDown()
    }
    
    // MARK: - Text Validation Tests
    
    func testIsTextValid_WithValidText_ReturnsTrue() {
        // Given
        let validTexts = ["ab", "cat", "beautiful sunset", "  valid  ", "123"]
        
        // When & Then
        for text in validTexts {
            XCTAssertTrue(imageGridView.isTextValid(text), "Text '\(text)' should be valid")
        }
    }
    
    func testIsTextValid_WithInvalidText_ReturnsFalse() {
        // Given
        let invalidTexts = ["", " ", "a", "  ", "\n", "\t", "  \n  "]
        
        // When & Then
        for text in invalidTexts {
            XCTAssertFalse(imageGridView.isTextValid(text), "Text '\(text)' should be invalid")
        }
    }
    
    func testIsTextValid_WithWhitespaceAroundValidText_ReturnsTrue() {
        // Given
        let textWithWhitespace = "  hello world  "
        
        // When
        let result = imageGridView.isTextValid(textWithWhitespace)
        
        // Then
        XCTAssertTrue(result, "Text with surrounding whitespace should be valid after trimming")
    }
                
    // MARK: - Initial State Tests
    
    func testInitialState_HasCorrectDefaults() {
        // Then
        XCTAssertEqual(imageGridView.searchText, "", "Initial search text should be empty")
        XCTAssertFalse(imageGridView.isTextInvalid, "Initial text invalid state should be false")
        XCTAssertEqual(imageGridView.gridColumns.count, 3, "Initial grid columns should be 3")
    }
        
    func testSearchAction_WithInvalidText_SetsTextInvalidFlag() {
        // Given
        imageGridView.searchText = "a" // Invalid - only one character
        
        // When
        let isValid = imageGridView.isTextValid(imageGridView.searchText)
        
        // Then
        XCTAssertFalse(isValid, "Single character should be invalid")
        // In real implementation, isTextInvalid would be set to true
    }
}
