//
//  Functions.swift
//  MyLocations
//
//  Created by Luis Faz on 2/11/24.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(
    deadline: .now() + seconds,
    execute: run)
}
