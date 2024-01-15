import MacroTester
import MemberwiseInitializerMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
  "MemberwiseInitializer": MemberwiseInitializerMacro.self
]

final class MemberwiseInitializerTests: XCTestCase {
  func testMemberwiseInitializer() throws {
    testMacro(macros: testMacros)
  }

  func testMemberwiseInitializerWithConstant() throws {
    testMacro(macros: testMacros)
  }
}
