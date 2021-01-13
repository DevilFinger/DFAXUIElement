//
//  AXError+DFBase.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/6.
//

import Foundation

extension AXError: Error {}

extension AXError {
    
    @usableFromInline func throwIfError() throws {
        if self != .success {
            throw self
        }
    }
}
