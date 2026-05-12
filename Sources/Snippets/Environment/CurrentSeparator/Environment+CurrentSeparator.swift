import Dependencies

extension DependencyValues {
	private enum SnippetSeparatorKey<Output: SnippetRepresentableLiteral>: SnippetEnvironmentKey {
		typealias Value = AnySnippet<Output>
		static var defaultValue: AnySnippet<Output> { AnySnippet(Snippets.Const.empty) }
	}

	@_spi(Internals)
	public struct SnippetSeparatorKeyID<Output: SnippetRepresentableLiteral>: Hashable, Sendable {
		let id: ObjectIdentifier = .init(Output.self)
		static func type(_ type: Output.Type) -> Self { .init() }
	}

	@_spi(Internals)
	public subscript<Output: SnippetRepresentableLiteral>(
		snippetSeparatorOf _: SnippetSeparatorKeyID<Output>
	) -> AnySnippet<Output> {
		get { self[SnippetSeparatorKey<Output>.self] }
		set { self[SnippetSeparatorKey<Output>.self] = newValue }
	}
}

extension SnippetEnvironmentValues {
	/// Default separator (empty)
	public var emptySeparator: some Snippet<Output> {
		Snippets.Const.empty
	}

	/// Current separator for ``\_StaticSnippetOutputCollector._collect(_:)`` implementations
	///
	/// Overriden for rendering by `Join` and `Append` snippets
	public var separator: some Snippet<Output> {
		return dependency(\.[snippetSeparatorOf: .type(Output.self)])
	}

	@_spi(Internals)
	public func performWithoutSeparator<R>(
		_ operation: () throws -> R
	) rethrows -> R {
		try withSeparator(emptySeparator, perform: operation)
	}

	@_spi(Internals)
	public func withSeparator<R>(
		_ separator: some Snippet<Output>,
		perform operation: () throws -> R
	) rethrows -> R {
		try withDependencies {
			$0[snippetSeparatorOf: .type(Output.self)] = AnySnippet(separator)
		} operation: {
			try operation()
		}
	}
}

extension Snippet {
	@_spi(Internals)
	public func performWithoutSeparator<R>(
		_ operation: () throws -> R
	) rethrows -> R {
		try Self.environment().performWithoutSeparator(operation)
	}

	@_spi(Internals)
	public func withSeparator<R>(
		_ separator: some Snippet<Output>,
		perform operation: () throws -> R
	) rethrows -> R {
		try Self.environment().withSeparator(separator, perform: operation)
	}
}
