//
//  AssetDetailVM.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation

final class AssetDetailVM: AssetDetailVMProtocol {    
    let outputStream: AsyncStreamResult<AssetDetailVMOutput>
    private let inputStream: AsyncStreamResult<AssetDetailVMInput>

    weak var coordinatorDelegate: (any AssetDetailVMCoordinatorDelegate)?

    init(coordinatorDelegate: (any AssetDetailVMCoordinatorDelegate)? = nil) {
        self.coordinatorDelegate = coordinatorDelegate

        inputStream = AsyncStream.makeStream(of: AssetDetailVMInput.self)
        outputStream = AsyncStream.makeStream(of: AssetDetailVMOutput.self)

        subscribeToTerminationStreams()

        Task {
            await handleInputEvents()
        }
    }

    func send(input: AssetDetailVMInput) {
        inputStream.continuation.yield(input)
    }
}

// MARK: Input / Output
private extension AssetDetailVM {

    func send(output: AssetDetailVMOutput) {
        outputStream.continuation.yield(output)
    }

    func subscribeToTerminationStreams() {
        inputStream.continuation.onTermination = { @Sendable [weak self] _ in
            self?.inputStream.continuation.finish()
        }

        outputStream.continuation.onTermination = { @Sendable [weak self] _ in
            self?.outputStream.continuation.finish()
        }
    }

    func handleInputEvents() async {
        for await event in inputStream.stream {
            switch event {
            case .appear:
                print("Handling appear event")
                send(output: .idle)
            }
        }
    }
}
