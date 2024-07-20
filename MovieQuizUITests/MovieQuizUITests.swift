import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        
        continueAfterFailure = false
        
        
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
        
    }
    
    func testYesButton() {

        sleep(3)
        
        let firstPoster = app.images["Poster"]
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        // XCTAssertFalse(firstPosterData == secondPosterData) // первый способо сравнения
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // второй способ сравнения
    
    }
    
    func testNoButton() {
        
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        let indexLabel = app.staticTexts["Index"]
        
        
        // XCTAssertFalse(firstPosterData == secondPosterData) // первый способо сравнения
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // второй способ сравнения
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testShowAlert() {
        
        sleep(3)
        
        for _ in 1...10 {
            
            app.buttons["Yes"].tap()
            sleep(5)
            
        }
        
        let alerts = app.alerts["quizAlert"]
        
        XCTAssertTrue(alerts.exists)
        XCTAssertTrue(alerts.label == "Раунд окончен!\n")
        XCTAssertTrue(alerts.buttons.firstMatch.label == "Да")
        
    }
    
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
        
    }
    
}
