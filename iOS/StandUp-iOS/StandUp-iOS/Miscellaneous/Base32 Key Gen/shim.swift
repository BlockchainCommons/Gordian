//
//  shim.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//  Copyright (c) 2015 Norio Nomura

import Foundation

#if !compiler(>=5)
extension Data {
    func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
        return try withUnsafeBytes {
            try apply(UnsafeRawBufferPointer(start: $0, count: count))
        }
    }
}
#endif
