import XCTest

final class DemoTests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--reset-journal"]
        app.launch()
        XCTAssertTrue(app.buttons["hero-explore"].waitForExistence(timeout: 15))
    }

    private func pause(_ seconds: Double = 1.5) { Thread.sleep(forTimeInterval: seconds) }

    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testRecordTravelExperience() {
        pause(2)
        let started = Date().timeIntervalSince1970
        print("DEMO_START_EPOCH=\(started)")
        capture("01-Explore")
        pause(2)
        app.buttons["hero-explore"].tap()
        XCTAssertTrue(app.buttons["save-kirkjufell"].waitForExistence(timeout: 5))
        pause()
        app.buttons["save-kirkjufell"].tap()
        app.buttons["route-kirkjufell"].tap()
        pause()
        capture("02-Kirkjufell")
        app.swipeUp()
        pause(2)
        app.buttons["detail-back"].tap()
        pause()
        app.swipeUp()
        pause()
        app.buttons["category-瀑布"].tap()
        pause()
        app.buttons["destination-skogafoss"].tap()
        XCTAssertTrue(app.buttons["save-skogafoss"].waitForExistence(timeout: 5))
        pause()
        app.buttons["save-skogafoss"].tap()
        app.buttons["route-skogafoss"].tap()
        pause()
        capture("03-Skogafoss")
        app.buttons["detail-back"].tap()
        app.tabBars.buttons["行程"].tap()
        pause(2)
        capture("04-Journey")
        app.swipeUp()
        pause()
        app.buttons["edit-route"].tap()
        pause()
        app.buttons["將斯科加瀑布上移"].tap()
        pause()
        app.buttons["edit-route"].tap()
        app.tabBars.buttons["收藏"].tap()
        pause(2)
        capture("05-Saved")
        app.tabBars.buttons["探索"].tap()
        pause()
        app.swipeDown()
        app.swipeDown()
        pause()
        app.buttons["冰島旅行手冊"].tap()
        pause()
        capture("06-Guide")
        app.buttons["完成"].tap()
        pause(2)
        let ended = Date().timeIntervalSince1970
        print("DEMO_END_EPOCH=\(ended)")
        let timing = XCTAttachment(string: "{\"start\":\(started),\"end\":\(ended)}")
        timing.name = "demo-timing"
        timing.lifetime = .keepAlways
        add(timing)
    }

    func testSearchAndPersistence() {
        app.swipeUp()
        let search = app.textFields["destination-search"]
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("Jokulsarlon")
        // Diacritic-insensitive localized search also accepts the native name.
        search.clearAndEnter("冰河湖")
        let lagoon = app.buttons["destination-lagoon"]
        XCTAssertTrue(lagoon.waitForExistence(timeout: 5))
        lagoon.tap()
        app.buttons["save-lagoon"].tap()
        app.buttons["route-lagoon"].tap()
        app.terminate()
        app.launchArguments = []
        app.launch()
        app.tabBars.buttons["收藏"].tap()
        XCTAssertTrue(app.staticTexts["傑古沙龍冰河湖"].waitForExistence(timeout: 5))
        app.tabBars.buttons["行程"].tap()
        XCTAssertTrue(app.staticTexts["1 個停留點 · 按加入順序排列"].waitForExistence(timeout: 5))
    }
}

private extension XCUIElement {
    func clearAndEnter(_ text: String) {
        tap()
        let current = value as? String ?? ""
        typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        typeText(text)
    }
}
