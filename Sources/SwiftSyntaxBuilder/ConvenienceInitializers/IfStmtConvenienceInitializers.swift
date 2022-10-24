//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

public extension IfStmt {
  /// A convenience initializer that uses builder closures to express an
  /// if body, potentially with a second trailing builder closure for an else
  /// body.
  init(
    leadingTrivia: Trivia = [],
    conditions: ConditionElementList,
    @CodeBlockItemListBuilder body: () -> CodeBlockItemList,
    @CodeBlockItemListBuilder elseBody: () -> CodeBlockItemList? = { nil }
  ) {
    let generatedElseBody = elseBody()
    self.init(
      leadingTrivia: leadingTrivia,
      conditions: conditions,
      body: CodeBlockSyntax(statements: body()),
      elseKeyword: generatedElseBody == nil ? nil : Token.else.withLeadingTrivia(.space).withTrailingTrivia([]),
      elseBody: generatedElseBody.map { .codeBlock(CodeBlock(statements: $0)) }
    )
  }
}
