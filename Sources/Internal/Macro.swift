internal import MacroHelper
public import SwiftDiagnostics
public import SwiftSyntax
public import SwiftSyntaxMacros

public struct MemberwiseInitializerMacro: MemberMacro {
  public enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresStruct = "#MemberwiseInitializer requires a struct"
    case requiresTypedStoredProperties =
      "#MemberwiseInitializer requires explicit type annotations on stored properties"

    public var message: String { rawValue }

    public var diagnosticID: MessageID {
      MessageID(domain: "MemberwiseInitializer", id: rawValue)
    }

    public var severity: DiagnosticSeverity { .error }
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

    let bindings = structDeclaration.storedPropertyBindings(includingStatic: false)

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
