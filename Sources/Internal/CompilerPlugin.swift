internal import SwiftCompilerPlugin
internal import SwiftSyntaxMacros

@main
struct MemberwiseInitializerPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    MemberwiseInitializerMacro.self
  ]
}
