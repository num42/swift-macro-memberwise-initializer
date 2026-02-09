import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MemberwiseInitializerMacro: MemberMacro {
  enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresStruct = "#MemberwiseInitializer requires a struct"
    case requiresTypedStoredProperties =
      "#MemberwiseInitializer requires explicit type annotations on stored properties"

    var message: String { rawValue }

    var diagnosticID: MessageID {
      MessageID(domain: "MemberwiseInitializer", id: rawValue)
    }

    var severity: DiagnosticSeverity { .error }
  }

  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresStruct
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let bindings = structDeclaration.memberBlock.members
      .compactMap { $0 }
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter { !($0.modifiers).contains { $0.name.text == "static" } }
      .flatMap(\.bindings)
      .filter { $0.accessorBlock == nil }

    guard bindings.allSatisfy({ $0.typeAnnotation != nil }) else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresTypedStoredProperties
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let parameters = bindings.map { "\($0.pattern): \($0.typeAnnotation!.type)" }.joined(
      separator: ", ")
    let header = SyntaxNodeString(stringLiteral: "public init(\(parameters))")

    let initializer = try! InitializerDeclSyntax(header) {
      CodeBlockItemListSyntax(
        bindings.map { "self.\($0.pattern) = \($0.pattern)" }.map {
          CodeBlockItemListSyntax.Element(stringLiteral: $0)
        }
      )
    }

    return [
      DeclSyntax(initializer)
    ]
  }
}
