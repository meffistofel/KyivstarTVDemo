//
//  AssetDetailVMType.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation

protocol AssetDetailVMProtocol {
    var outputStream: AsyncStreamResult<AssetDetailVMOutput> { get }

    func send(input: AssetDetailVMInput)
}

// MARK: Coordinator Delegate
protocol AssetDetailVMCoordinatorDelegate: AnyObject {

}

enum AssetDetailVMInput {
    case appear
}

enum AssetDetailVMOutput {
    case idle
    case error(Error)
}
