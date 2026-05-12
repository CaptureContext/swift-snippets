import CustomDump
import Snippets
import Testing

@Suite("Builder closures")
struct BuilderClosureTests {
	@Test
	func acceptsEmptyClosure() async throws {
		let value: String = .snippet {}

		expectNoDifference("", value)
	}

	@Test
	func acceptsSingleSnippetExpression() async throws {
		let value: String = .snippet {
			"value"
		}

		expectNoDifference("value", value)
	}

	@Test
	func acceptsMultipleSnippetExpressions() async throws {
		let value: String = .snippet {
			"a"
			"b"
			"c"
		}

		expectNoDifference("abc", value)
	}

	@Test
	func acceptsConditionalBranches() async throws {
		let enabled = true
		let value: String = .snippet {
			"prefix"
			if enabled {
				"-enabled"
			} else {
				"-disabled"
			}
		}

		expectNoDifference("prefix-enabled", value)
	}

	@Test
	func acceptsOptionalBranchWhenPresent() async throws {
		let enabled = true
		let value: String = .snippet {
			"prefix"
			if enabled {
				"-enabled"
			}
		}

		expectNoDifference("prefix-enabled", value)
	}

	@Test
	func acceptsOptionalBranchWhenAbsent() async throws {
		let enabled = false
		let value: String = .snippet {
			"prefix"
			if enabled {
				"-enabled"
			}
		}

		expectNoDifference("prefix", value)
	}

	@Test
	func acceptsOptionalSnippetExpressionWhenPresent() async throws {
		let suffix: String.SnippetRepresentation? = "-suffix".makeSnippet()
		let value: String = .snippet {
			"prefix"
			suffix
		}

		expectNoDifference("prefix-suffix", value)
	}

	@Test
	func acceptsOptionalSnippetExpressionWhenAbsent() async throws {
		let suffix: String.SnippetRepresentation? = nil
		let value: String = .snippet {
			"prefix"
			suffix
		}

		expectNoDifference("prefix", value)
	}

	@Test
	func acceptsArrayOfSnippetExpressions() async throws {
		let snippets = [
			"a".makeSnippet(),
			"b".makeSnippet(),
			"c".makeSnippet(),
		]
		let snippet: some Snippet<String> = Snippets.Join(.const("-")) {
			snippets
		}

		expectNoDifference("a-b-c", snippet.render())
	}

	@Test
	func acceptsSnippetExistentials() async throws {
		let snippetExpression: any Snippet<String> = "value".makeSnippet()
		let value: String = .snippet {
			"prefix-"
			snippetExpression
		}

		expectNoDifference("prefix-value", value)
	}

	@Test
	func acceptsRepresentableValues() async throws {
		let suffix = "value"
		let value: String = .snippet {
			"prefix-"
			suffix
		}

		expectNoDifference("prefix-value", value)
	}

	@Test
	func acceptsSingleInputBuilderClosure() async throws {
		let snippet = UnaryClosureSnippet("value") { value in
			"prefix-"
			value
		}

		expectNoDifference("prefix-value", snippet.render())
	}

	@Test
	func acceptsMultipleInputBuilderClosure() async throws {
		let snippet = BinaryClosureSnippet("left", "right") { left, right in
			left
			"-"
			right
		}

		expectNoDifference("left-right", snippet.render())
	}
}
