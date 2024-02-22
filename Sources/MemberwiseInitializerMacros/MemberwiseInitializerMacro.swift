import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MemberwiseInitializerMacro: MemberMacro {
  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
      return []
    }

    let bindings = structDeclaration.memberBlock.members
      .compactMap { $0.as(MemberBlockItemSyntax.self) }
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter { !($0.modifiers).contains { $0.name.text == "static" } }
      .flatMap(\.bindings)
      .filter { $0.accessorBlock == nil }

    var parameters = [String]()
    var initializations = [String]()
    
      bindings.forEach {
      guard let typeAnnotation = $0.typeAnnotation else { return }
      var typeAnnotationText = "\(typeAnnotation.type)"

      // Detect if the property is a closure
      if typeAnnotationText.contains("() ->") && !typeAnnotationText.contains("@escaping") {
        typeAnnotationText = "@escaping " + typeAnnotationText
      }
            
      // Prepare parameter string, auto-nil for optional values
      let defaultValue = (typeAnnotationText.contains("?") || typeAnnotationText.contains("= nil")) ? " = nil" : ""
        let parameter = "\($0.pattern): \(typeAnnotationText)\(defaultValue)"
      parameters.append(parameter)
      
      // Prepare initialization string
        let initialization = "self.\($0.pattern) = \($0.pattern)"
      initializations.append(initialization)
    }

    let header = SyntaxNodeString(stringLiteral: "public init(\(parameters.joined(separator: ", ")))")

    let initializer = try! InitializerDeclSyntax(header) {
      CodeBlockItemListSyntax(
        initializations.map { CodeBlockItemListSyntax.Element(stringLiteral: $0) }
      )
    }

    return [
      DeclSyntax(initializer)
    ]
  }
}

@main
struct MemberwiseInitializerPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    MemberwiseInitializerMacro.self
  ]
}
