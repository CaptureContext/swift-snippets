import CustomDump
import Snippets
import Testing

@Suite("Snippets.Map")
struct MapTests {
	@Test
	func mapsRenderedOutput() async throws {
		let snippet = Snippets.Map("value".makeSnippet()) { output in
			output.uppercased()
		}

		expectNoDifference("VALUE", snippet.render())
	}

	@Test
	func mapsSnippetBuiltByClosure() async throws {
		let input: String = .snippet {
			"a"
			"b"
		}
		let snippet = Snippets.Map(input.makeSnippet()) { output in
			"[\(output)]"
		}

		expectNoDifference("[ab]", snippet.render())
	}

	@Test
	func mapsUsingSnippetExtension() async throws {
		let snippet = "value".makeSnippet().map { output in
			output.replacingOccurrences(of: "a", with: "A")
		}

		expectNoDifference("vAlue", snippet.render())
	}
}

@Suite("Snippets.FlatMap")
struct FlatMapTests {
	@Test
	func flatMapsRenderedOutput() async throws {
		let snippet = Snippets.FlatMap("value".makeSnippet()) { output in
			"["
			output.uppercased()
			"]"
		}

		expectNoDifference("[VALUE]", snippet.render())
	}

	@Test
	func flatMapsSnippetBuiltByClosure() async throws {
		let input: String = .snippet {
			"a"
			"b"
		}
		let snippet = Snippets.FlatMap(input.makeSnippet()) { output in
			output
			"c"
		}

		expectNoDifference("abc", snippet.render())
	}

	@Test
	func flatMapsUsingSnippetExtension() async throws {
		let snippet = flatMapValue { output in
			"<"
			output
			">"
		}

		expectNoDifference("<value>", snippet.render())
	}
}
