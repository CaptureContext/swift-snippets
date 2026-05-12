import Dependencies

extension DependencyValues {
	private enum SnippetCollectPreprocessorKey<
		Output: SnippetRepresentableLiteral
	>: SnippetEnvironmentKey {
		typealias Value = @Sendable ([Output]) -> [Output]
		static var defaultValue: Value {
			uncheckedSendableAction { $0 }
		}
	}

	@_spi(Internals)
	public struct SnippetCollectPreprocessorKeyID<Output: SnippetRepresentableLiteral>: Hashable, Sendable {
		let id: ObjectIdentifier = .init(Output.self)
		static func type(_ type: Output.Type) -> Self { .init() }
	}

	@_spi(Internals)
	public mutating func resetSnippetCollectPreprocessor<Output: SnippetRepresentableLiteral>(
		for outputType: Output.Type
	) {
		self[snippetCollectPreprocessorOf: .type(outputType)]
		= uncheckedSendableAction { $0 }
	}

	@_spi(Internals)
	public subscript<Output: SnippetRepresentableLiteral>(
		snippetCollectPreprocessorOf _: SnippetCollectPreprocessorKeyID<Output>
	) -> @Sendable ([Output]) -> [Output] {
		get { self[SnippetCollectPreprocessorKey<Output>.self] }
		set { self[SnippetCollectPreprocessorKey<Output>.self] = newValue }
	}
}

extension SnippetEnvironmentValues {
	/// Current preprocessor that is meant to preprocess arguments for
	/// ``\_StaticSnippetOutputCollector._collect(_:)``  method
	public var collectPreprocessor: @Sendable ([Output]) -> [Output] {
		return dependency(\.[snippetCollectPreprocessorOf: .type(Output.self)])
	}

	/// Collector that bypasses all arguments to ``\_StaticSnippetOutputCollector._collect(_:)`` as is
	public var nonprocessingOutputCollector: @Sendable ([Output]) -> Output {
		return uncheckedSendableAction { outputs in
			Output.SnippetRepresentation._collect(outputs)
		}
	}

	/// Default output collector that applies ``collectPreprocessor``
	/// before passing arguments to ``\_StaticSnippetOutputCollector._collect(_:)``
	public var outputCollector: @Sendable ([Output]) -> Output {
		return uncheckedSendableAction { outputs in
			Output.SnippetRepresentation._collect(self.collectPreprocessor(outputs))
		}
	}
}

extension Snippet {
	/// Sets preprocessor for next `withOutputCollector` call
	///
	/// Should only be used in `render()` function call stack
	///
	/// See `.skipEmpty()` snippet for reference
	public func withNextOutputPreprocessor(
		_ preprocessor: @escaping @Sendable ([Output]) -> [Output],
		perform operation: () throws -> Output
	) rethrows -> Output {
		try withDependencies {
			$0[snippetCollectPreprocessorOf: .type(Output.self)] = preprocessor
		} operation: {
			try operation()
		}
	}

	/// Provides output collector for operationll
	///
	/// Should only be used in `render()` function call stack
	///
	/// See `SnippetBuilder` for reference
	public func withOutputCollector(
		fileID: StaticString = #fileID,
		filePath: StaticString = #filePath,
		line: UInt = #line,
		column: UInt = #column,
		perform operation: (@Sendable ([Output]) -> Output) throws -> Output
	) rethrows -> Output {
		let preprocessor = Dependency(
			\.[snippetCollectPreprocessorOf: .type(Output.self)],
			fileID: fileID,
			filePath: filePath,
			line: line,
			column: column
		).wrappedValue

		return try withDependencies {
			$0.resetSnippetCollectPreprocessor(for: Output.self)
		} operation: {
			try operation { outputs in
				Output.SnippetRepresentation._collect(preprocessor(outputs))
			}
		}
	}
}
