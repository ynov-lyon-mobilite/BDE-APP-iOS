//
//  SignUpAssembly.swift
//  App-BDE-iOS
//
//  Created by Nicolas Barbosa on 23/01/2021.
//

import Swinject
import SwinjectAutoregistration

final class SignUpAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SignUpViewModel.self) { _ -> SignUpViewModel in
            return SignUpViewModel()
        }

        container.register(SignUpView.self) { r -> SignUpView in
            let viewModel = r.resolve(SignUpViewModel.self)!

            return SignUpView(viewModel: viewModel)
        }
    }
}
