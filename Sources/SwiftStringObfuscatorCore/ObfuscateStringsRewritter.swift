//
//  ObfuscateStringsRewritter.swift
//  string_obfuscator
//
//  Created by Lukas Gergel on 01.01.2021.
//

import Foundation
import SwiftSyntax

enum State {
    case reading
    case command
}

class ObfuscateStringsRewritter: SyntaxRewriter {
    var state: State = .reading
    
    func integerLiteralElement(_ int: Int, addComma: Bool = true) -> ArrayElementSyntax {
        let literal = SyntaxFactory.makeIntegerLiteral("\(int)")
        return SyntaxFactory.makeArrayElement(
            expression: ExprSyntax(SyntaxFactory.makeIntegerLiteralExpr(digits: literal)),
            trailingComma: addComma ? SyntaxFactory.makeCommaToken() : nil)
    }

    override open func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        defer {
            state = .reading
        }
        guard case .command = state else { return super.visit(node) }
        let origValue = "\(node.segments)"
        let bytes = origValue.bytes.enumerated().map { (i, element) -> ArrayElementSyntax in
            integerLiteralElement(Int(element), addComma: i < origValue.bytes.count - 1)
        }
        let arrayElementList = SyntaxFactory.makeArrayElementList(bytes)

        let bytesArg = SyntaxFactory.makeTupleExprElement(
            label: SyntaxFactory.makeIdentifier("bytes"),
            colon: SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)),
            expression: ExprSyntax(SyntaxFactory.makeArrayExpr(
                leftSquare: SyntaxFactory.makeLeftSquareBracketToken(),
                elements: arrayElementList,
                rightSquare: SyntaxFactory.makeRightSquareBracketToken())),
            trailingComma: SyntaxFactory.makeCommaToken()
        )

        let encodingArg = SyntaxFactory.makeTupleExprElement(
            label: SyntaxFactory.makeIdentifier("encoding"),
            colon: SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)),
            expression: ExprSyntax(SyntaxFactory.makeIdentifierExpr(identifier: SyntaxFactory.makeIdentifier(".utf8"),
                                                                    declNameArguments: nil)),
            trailingComma: nil
        ).withLeadingTrivia(.spaces(1))

        let newCall =
            SyntaxFactory.makeFunctionCallExpr(
                calledExpression: ExprSyntax(
                    SyntaxFactory.makeIdentifierExpr(
                        identifier: SyntaxFactory.makeIdentifier("String"),
                        declNameArguments: nil
                    )
                ),
                leftParen: SyntaxFactory.makeLeftParenToken(),
                argumentList: SyntaxFactory.makeTupleExprElementList([bytesArg, encodingArg]),
                rightParen: SyntaxFactory.makeRightParenToken(),
                trailingClosure: nil,
                additionalTrailingClosures: nil
            )
        return super.visit(newCall)
    }

    override func visit(_ token: TokenSyntax) -> Syntax {
        let withoutSpaces = token.leadingTrivia.filter { if case .spaces = $0 { return false }; return true }
        guard withoutSpaces.count > 1 else { return super.visit(token) }
        let lastNewLine = withoutSpaces.last
        let commandLine = withoutSpaces[withoutSpaces.count-2]
        
        if state == .reading, case .newlines(1) = lastNewLine, case .lineComment("//:obfuscate") = commandLine {
            state = .command
        }
        return super.visit(token)
    }
}

struct FileHandlerOutputStream: TextOutputStream {
    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}
