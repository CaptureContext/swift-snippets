import CustomDump
import Snippets
import Testing

@Suite("Snippets.Inline")
struct InlineTests {
	@Test
	func rendersClosureOutput() async throws {
		let snippet = Snippets.Inline<String> {
			"dynamic"
		}

		expectNoDifference("dynamic", snippet.render())
	}

	@Test
	func participatesInBuilderClosures() async throws {
		let value: String = .snippet {
			"before"
			Snippets.Inline<String> { "middle" }
			"after"
		}

		expectNoDifference("beforemiddleafter", value)
	}
}
