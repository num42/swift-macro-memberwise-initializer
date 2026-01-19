import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

#if canImport(MemberwiseInitializerMacros)
  import MemberwiseInitializerMacros

  let testMacros: [String: Macro.Type] = [
    "MemberwiseInitializer": MemberwiseInitializerMacro.self
  ]

  @Suite
  struct MemberwiseInitializerMacroTests {
    @Test func memberwiseInitializer() {
      MacroTester.testMacro(macros: testMacros)
    }

    @Test func memberwiseInitializerWithConstant() {
      MacroTester.testMacro(macros: testMacros)
    }
  }
#endif
