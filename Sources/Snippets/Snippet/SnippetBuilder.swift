@resultBuilder
public enum SnippetBuilder<Output: SnippetRepresentableLiteral> {
	@inlinable
	public static func buildBlock() -> some Snippet<Output> {
		Output.SnippetRepresentation()
	}

	@inlinable
	public static func buildPartialBlock<
		Component: Snippet<Output>
	>(
		first: Component
	) -> some Snippet<Output> {
		first
	}

	@inlinable
	public static func buildPartialBlock<
		Accumulated: Snippet<Output>,
		Next: Snippet<Output>
	>(
		accumulated: Accumulated,
		next: Next
	) -> some Snippet<Output> {
		_Sequence(accumulated, next)
	}

	@inlinable
	public static func buildEither<
		S0: Snippet<Output>,
		S1: Snippet<Output>
	>(
		first component: S0
	) -> _Conditional<S0, S1> {
		.first(component)
	}

	@inlinable
	public static func buildEither<
		S0: Snippet<Output>,
		S1: Snippet<Output>
	>(
		second component: S1
	) -> _Conditional<S0, S1> {
		.second(component)
	}

	@inlinable
	public static func buildIf<
		Content: Snippet<Output>
	>(
		_ content: Content?
	) -> Content? {
		content
	}

	@inlinable
	public static func buildOptional<
		Component: Snippet<Output>
	>(
		_ component: Component?
	) -> some Snippet<Output> {
		_Optional(component)
	}

	@inlinable
	public static func buildArray<
		Component: Snippet<Output>
	>(
		_ components: [Component]
	) -> some Snippet<Output> {
		_SequenceMany(components)
	}

	@inlinable
	public static func buildExpression(
		_ component: any Snippet<Output>
	) -> some Snippet<Output> {
		AnySnippet(component)
	}

	@inlinable
	public static func buildExpression<
		Component: Snippet<Output>
	>(
		_ component: Component?
	) -> some Snippet<Output> {
		_Optional(component)
	}

	@inlinable
	public static func buildExpression(
		_ expression: Output
	) -> some Snippet<Output> {
		expression.makeSnippet()
	}

	@inlinable
	public static func buildExpression(
		_ expression: some Snippet<Output>
	) -> some Snippet<Output> {
		expression
	}

	@inlinable
	public static func buildExpression(
		_ expression: [some Snippet<Output>]
	) -> some Snippet<Output> {
		buildArray(expression)
	}

	@inlinable
	public static func buildExpression<S: SnippetRepresentable>(
		_ expression: [Output.SnippetRepresentation]
	) -> some Snippet<Output> where S.SnippetRepresentation.Output == Output {
		buildArray(expression)
	}

	@inlinable
	public static func buildExpression<S: SnippetRepresentable>(
		_ expression: S
	) -> some Snippet<Output> where S.SnippetRepresentation.Output == Output {
		expression.makeSnippet()
	}

	@inlinable
	public static func buildFinalResult<
		Component: Snippet<Output>
	>(
		_ component: Component
	) -> some Snippet<Output> {
		component
	}

	public enum _Conditional<
		First: Snippet<Output>,
		Second: Snippet<Output>
	>: Snippet {
		case first(First)
		case second(Second)

		@inlinable
		public func render() -> Output {
			switch self {
			case let .first(first):
				return first.render()

			case let .second(second):
				return second.render()
			}
		}
	}

	public enum _Optional<
		Contents: Snippet<Output>
	>: Snippet {
		case some(Contents)
		case none

		public init(_ content: Contents?) {
			self = switch content {
			case let .some(content): .some(content)
			case .none: .none
			}
		}

		@inlinable
		public func render() -> Output {
			switch self {
			case let .some(contents):
				return contents.render()

			case .none:
				return Snippets.Const.empty.render()
			}
		}
	}

	public struct _Sequence<
		A: Snippet<Output>,
		B: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let a: A

		@usableFromInline
		internal let b: B

		public init(
			_ a: A,
			_ b: B
		) {
			self.a = a
			self.b = b
		}

		@inlinable
		public func render() -> Output {
			withOutputCollector { collect in
				collect(renderOutputs(for: self))
			}
		}
	}

	public struct _SequenceMany<
		Element: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let elements: [Element]

		public init(_ elements: [Element]) {
			self.elements = elements
		}

		@inlinable
		public func render() -> Output {
			withOutputCollector { collect in
				collect(renderOutputs(for: self))
			}
		}
	}
}

@_spi(Internals)
public protocol _ContainerSnippetProtocol<Output>: Snippet {
	func _renderOutputs() -> [Output]
}

@usableFromInline
func renderOutputs<Output>(
	for snippet: some Snippet<Output>
) -> [Output] {
	if
		let snippet = snippet as? any _ContainerSnippetProtocol,
		let outputs = snippet._renderOutputs() as? [Output]
	{
		return outputs
	} else {
		return [snippet.render()]
	}
}

@_spi(Internals)
extension SnippetBuilder._SequenceMany: _ContainerSnippetProtocol {
	public func _renderOutputs() -> [Output] {
		return elements.flatMap(renderOutputs(for:))
	}
}

@_spi(Internals)
extension SnippetBuilder._Sequence: _ContainerSnippetProtocol {
	public func _renderOutputs() -> [Output] {
		return renderOutputs(for: a) + renderOutputs(for: b)
	}
}

@_spi(Internals)
extension SnippetBuilder._Conditional: _ContainerSnippetProtocol {
	public func _renderOutputs() -> [Output] {
		switch self {
		case let .first(snippet):
			return renderOutputs(for: snippet)
		case let .second(snippet):
			return renderOutputs(for: snippet)
		}
	}
}

@_spi(Internals)
extension SnippetBuilder._Optional: _ContainerSnippetProtocol {
	public func _renderOutputs() -> [Output] {
		switch self {
		case let .some(snippet):
			return renderOutputs(for: snippet)
		case .none:
			return []
		}
	}
}
