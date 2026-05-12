import Dependencies
import Foundation

extension Snippets {
	public struct Bracket<
		Output: SnippetRepresentableLiteral,
		Target: Snippet<Output>
	>: Snippet {
		public struct Brackets: Sendable {
			@usableFromInline
			internal let leading: Const<Output>

			@usableFromInline
			internal let trailing: Const<Output>

			public init(
				leading: Const<Output>,
				trailing: Const<Output>
			) {
				self.leading = leading
				self.trailing = trailing
			}

			public init(
				_ bracket: Const<Output>
			) {
				self.init(
					leading: bracket,
					trailing: bracket
				)
			}
		}

		@usableFromInline
		internal let target: Target

		@usableFromInline
		internal let brackets: Brackets

		public init(
			in brackets: Brackets,
			@SnippetBuilder<Output> target: () -> Target
		) {
			self.init(
				target(),
				in: brackets
			)
		}

		public init(
			_ target: Target,
			in brackets: Brackets
		) {
			self.target = target
			self.brackets = brackets
		}

		@inlinable
		public var content: some Snippet<Target.Output> {
			Join {
				brackets.leading
				target
				brackets.trailing
			}
		}
	}
}

extension Snippets.Bracket.Brackets {
	public func withInner(_ brackets: Self) -> Self {
		return .init(
			leading: leading.suffixed(with: brackets.leading),
			trailing: trailing.prefixed(with: brackets.trailing)
		)
	}

	public func withOuter(_ brackets: Self) -> Self {
		return .init(
			leading: leading.prefixed(with: brackets.leading),
			trailing: trailing.suffixed(with: brackets.trailing)
		)
	}
}

extension Snippets.Bracket.Brackets where Output: SnippetRepresentableString {
	@inlinable
	public static func backticks(_ count: Int = 1) -> Self {
		.init(.backticks(count))
	}

	@inlinable
	public static func quotes(_ count: Int = 1) -> Self {
		.init(.quotes(count))
	}

	@inlinable
	public static var brackets: Self {
		return .init(
			leading: .leftBracket,
			trailing: .rightBracket
		)
	}

	@inlinable
	public static var braces: Self {
		return .init(
			leading: .leftBrace,
			trailing: .rightBrace
		)
	}

	@inlinable
	public static var parenthesis: Self {
		return .init(
			leading: .leftParenthesis,
			trailing: .rightParenthesis
		)
	}

	@inlinable
	public static var diamond: Self {
		return .init(
			leading: .lessThan,
			trailing: .greaterThan
		)
	}

	@inlinable
	public static var newlines: Self {
		return .init(
			leading: .newline,
			trailing: .newline
		)
	}
}
