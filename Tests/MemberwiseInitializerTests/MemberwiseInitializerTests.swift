import MacroTester
import MemberwiseInitializerMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

let testMacros: [String: Macro.Type] = [
  "MemberwiseInitializer": MemberwiseInitializerMacro.self
]

@Suite struct MemberwiseInitializerTests {
  @Test func memberwiseInitializer() {
      MacroTester.testMacro(macros: testMacros)
  }

  @Test func memberwiseInitializerWithConstant() {
      MacroTester.testMacro(macros: testMacros)
  }
}
