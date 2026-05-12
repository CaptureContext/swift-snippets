import CustomDump
import Snippets
import Testing

@Suite("Snippets.Append")
struct AppendTests {
	@Test
	func appendsBuilderContentsToSource() async throws {
		let snippet = Snippets.Append(
			to: Snippets.Const("prefix")
		) {
			"-"
			"suffix"
		}

		expectNoDifference("prefix-suffix", snippet.render())
	}

	@Test
	func doesNotInsertExtraSeparatorBetweenSourceAndRenderedContents() async throws {
		let snippet: some Snippet<String> = Snippets.Join(.const(",")) {
			Snippets.Append(to: "a".makeSnippet()) {
				"b"
				"c"
			}
			"d"
		}

		expectNoDifference("ab,c,d", snippet.render())
	}

	@Test
	func prefixesSnippet() async throws {
		let snippet = "value".makeSnippet().withPrefix("prefix-".makeSnippet())

		expectNoDifference("prefix-value", snippet.render())
	}

	@Test
	func suffixesSnippet() async throws {
		let snippet = "value".makeSnippet().withSuffix("-suffix".makeSnippet())

		expectNoDifference("value-suffix", snippet.render())
	}

	@Test
	func prefixesAndSuffixesLiteralValues() async throws {
		let value = Snippets.Const<String>("value")

		expectNoDifference("prefix-value", value.prefixed(with: "prefix-").render())
		expectNoDifference("value-suffix", value.suffixed(with: "-suffix").render())
	}
}
