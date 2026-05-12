import Foundation

extension Data: SnippetRepresentableLiteral {
	/// SnippetRepresentation for `Data` type
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {
		@usableFromInline
		internal let literal: Data

		public init(snippetLiteral: Data) {
			self.literal = snippetLiteral
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: .init())
		}

		@inlinable
		public func render() -> Data { literal }

		@inlinable
		public static func _collect(_ elements: [Output]) -> Output {
			.init(elements.joined(separator: environment(\.separator).render()))
		}
	}
}
