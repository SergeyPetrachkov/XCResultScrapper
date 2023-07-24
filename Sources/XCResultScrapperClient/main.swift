import Foundation

Thread {
    print("Starting XCResultScrapper")
    while true {
        print("......")
        Thread.sleep(forTimeInterval: 30)
    }
}
.start()

XCResultScrapperHostCommand.main()
