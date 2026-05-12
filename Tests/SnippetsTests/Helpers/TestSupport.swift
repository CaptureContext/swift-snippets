import Snippets

struct UnaryClosureSnippet<Input: Sendable, Content: Snippet<String>>: Snippet {
	let input: Input
	let build: @Sendable (Input) -> Content

	init(
		_ input: Input,
		@SnippetBuilder<String> content: @escaping @Sendable (Input) -> Content
	) {
		self.input = input
		self.build = content
	}

	func render() -> String {
		build(input).render()
	}
}

struct BinaryClosureSnippet<Input: Sendable, Content: Snippet<String>>: Snippet {
	let first: Input
	let second: Input
	let build: @Sendable (Input, Input) -> Content

	init(
		_ first: Input,
		_ second: Input,
		@SnippetBuilder<String> content: @escaping @Sendable (Input, Input) -> Content
	) {
		self.first = first
		self.second = second
		self.build = content
	}

	func render() -> String {
		build(first, second).render()
	}
}

func flatMapValue<Result: Snippet<String>>(
	@SnippetBuilder<String> transform: @escaping @Sendable (String) -> Result
) -> some Snippet<String> {
	"value".makeSnippet().flatMap(transform)
}
