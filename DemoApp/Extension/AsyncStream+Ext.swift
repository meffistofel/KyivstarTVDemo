//
//  AsyncStream+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation

typealias AsyncStreamResult<T> = (stream: AsyncStream<T>, continuation: AsyncStream<T>.Continuation)
