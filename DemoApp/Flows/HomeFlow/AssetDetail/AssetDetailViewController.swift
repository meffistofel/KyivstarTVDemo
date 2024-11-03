//
//  AssetDetailViewController.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import UIKit
import OSLog

private let logger = Logger(subsystem: "DemoApp", category: "AssetDetailViewController")

final class AssetDetailViewController: UIViewController {

    var viewModel: AssetDetailVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindOutput()
        viewModel.send(input: .appear)
    }
}

// MARK: - Bind

private extension AssetDetailViewController {
    func bindOutput() {
        Task {
            for await output in viewModel.outputStream.stream {
                render(output)
            }
        }
    }

    func render(_ state: AssetDetailVMOutput) {
        switch state {
        case .idle:
            print("Idle")
        case .error(let error):
            logger.error("\(error.localizedDescription)")
        }
    }
}
