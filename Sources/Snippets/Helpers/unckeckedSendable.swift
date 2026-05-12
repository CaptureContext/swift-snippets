private struct UncheckedSendableAction<Input, Output>: @unchecked Sendable {
	private let action: (Input) -> Output

	init(_ action: @escaping (Input) -> Output) {
		self.action = action
	}

	@Sendable
	func run(_ input: Input) -> Output {
		action(input)
	}
}

@usableFromInline
func uncheckedSendableAction<Input, Output>(
	_ action: @escaping (Input) -> Output
) -> @Sendable (Input) -> Output {
	UncheckedSendableAction(action).run
}
