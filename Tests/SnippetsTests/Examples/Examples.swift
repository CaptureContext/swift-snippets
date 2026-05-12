import CustomDump
import Snippets
import Testing

private struct Lowercased<Contents: Snippet<String>>: Snippet {
	let contents: Contents

	init(
		@SnippetBuilder<String> content: () -> Contents
	) {
		self.contents = content()
	}

	var content: some Snippet<String> {
		contents.map { $0.lowercased() }
	}
}

private struct Quoted<Contents: Snippet<String>>: Snippet {
	let contents: Contents

	init(
		@SnippetBuilder<String> content: () -> Contents
	) {
		self.contents = content()
	}

	func render() -> String {
		Snippets.Bracket(contents, in: .quotes()).render()
	}
}

// You can also make your simple snippets Codable
// even if `content` output is not Codable
//
// tho codable support for higher-order
// snippets is not implemented yet, so
// values have to be pre-rendered
private struct FunctionCall: Snippet, Codable {
	let name: String
	let arguments: String

	init<Arguments: Snippet<String>>(
		_ name: String,
		@SnippetBuilder<String> arguments: () -> Arguments
	) {
		self.name = name
		self.arguments = Snippets.Join(", ") {
			arguments()
		}
		.skipEmpty()
		.render()
	}

	var content: some Snippet<String> {
		name
		Snippets.Bracket(
			arguments.makeSnippet(),
			in: .parenthesis
		)
	}
}

@Suite("Examples")
struct ExecutableExamplesTests {
	@Test
	func composesAFunctionCallWithArguments() async throws {
		let snippet = FunctionCall("makeUser") {
			#"id: "42""#
			#"name: "Blob""#
		}

		expectNoDifference(#"makeUser(id: "42", name: "Blob")"#, snippet.render())
	}

	@Test
	func composesAFunctionCallWithoutEmptyArguments() async throws {
		let nickname: String? = nil
		let arguments = [
			Optional(#"id: "42""#),
			nickname.map { #"nickname: "\#($0)""# },
			Optional(#"isActive: true"#),
		]
		.compactMap { $0?.makeSnippet() }

		let snippet = FunctionCall("makeUser") {
			arguments
		}

		expectNoDifference(#"makeUser(id: "42", isActive: true)"#, snippet.render())
	}

	@Test
	func buildsReusableSnippetWithCompositionAPI() async throws {
		let snippet = Lowercased {
			"HELLO"
			" "
			"WORLD"
		}

		expectNoDifference("hello world", snippet.render())
	}

	@Test
	func buildsReusableSnippetWithImperativeAPI() async throws {
		let snippet = Quoted {
			"Hello, world!"
		}

		expectNoDifference(#""Hello, world!""#, snippet.render())
	}
}
