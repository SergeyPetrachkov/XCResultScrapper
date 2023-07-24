# XCResultScrapper

Read your xcresult, extract failed tests and failure reasons, list tests coverage per target and more.

## Currently available scenarios

`xcresultscrapper --path /path/to/your.xcresult --fetch-coverage true --output-path /path/to/your/output_directory/`

This will read through the XCResult, extract the data and prepare a markdown report with targets coverage and failed tests.

------------------------------------

`xcresultscrapper extract-swiftui-previews-coverage --path /path/to/your.xcresult --output-path /path/to/your/output_directory/`

This will produce an xml document with only SwiftUI previews lines per file.

------------------------------------

`xcresultscrapper coverage --path /path/to/your.xcresult --output-path /path/to/your/output_directory/`

This will produce an xml document with the full coverage data ignoring SwiftUI Previews code

------------------------------------

## Future plans

* Complete Junit integration
* Add tests
* Add docs
