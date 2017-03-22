import XCTest
@testable import StopTests
@testable import FindTests
@testable import DepartureTests
@testable import LineTests
@testable import MonitorTests
@testable import RouteChangeTests
@testable import RouteChangesTests

XCTMain([
    testCase(StopTests.allTests),
    testCase(FindTests.allTests),
    testCase(DepartureTests.allTests),
    testCase(LineTests.allTests),
    testCase(MonitorTests.allTests),
    testCase(RouteChangeTests.allTests),
    testCase(RouteChangesTests.allTests),
])
