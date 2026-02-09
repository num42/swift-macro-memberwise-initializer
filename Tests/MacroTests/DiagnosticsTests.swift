import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

#if canImport(MemberwiseInitializerMacros)
  import MemberwiseInitializerMacros

  @Suite struct MemberwiseInitializerDiagnosticsTests {
    let testMacros: [String: Macro.Type] = [
      "MemberwiseInitializer": MemberwiseInitializerMacro.self
    ]

    @Test func classThrowsError() {
      assertMacroExpansion(
        """
        @MemberwiseInitializer
        class AClass {
          let value: Int
          init(value: Int) { self.value = value }
        }
        """,
        expandedSource: """
          class AClass {
            let value: Int
            init(value: Int) { self.value = value }
          }
          """,
        diagnostics: [
          .init(
            message: MemberwiseInitializerMacro.MacroDiagnostic.requiresStruct.message,
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
      )
    }

    @Test func untypedStoredPropertyThrowsError() {
      assertMacroExpansion(
        """
        @MemberwiseInitializer
        struct UntypedProperty {
          let value = 1
        }
        """,
        expandedSource: """
          struct UntypedProperty {
            let value = 1
          }
          """,
        diagnostics: [
          .init(
            message: MemberwiseInitializerMacro.MacroDiagnostic.requiresTypedStoredProperties
              .message,
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
      )
    }
  }
#endif
