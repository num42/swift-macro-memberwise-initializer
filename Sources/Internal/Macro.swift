import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MemberwiseInitializerMacro: MemberMacro {
  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
      return []
    }

    let bindings = structDeclaration.memberBlock.members
      .compactMap { $0 }
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter { !($0.modifiers).contains { $0.name.text == "static" } }
      .flatMap(\.bindings)
      .filter { $0.accessorBlock == nil }

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
