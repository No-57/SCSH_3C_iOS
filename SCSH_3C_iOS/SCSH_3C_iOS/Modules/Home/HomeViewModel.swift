//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    // MARK: Output
    let firstHeaderIndex = CurrentValueSubject<Int, Never>(0)
    let hightLightHeaderIndex = CurrentValueSubject<Int, Never>(0)
    let themes = CurrentValueSubject<[HomeTheme], Never>([])
    
    @Published var navigationPath = NavigationPath()

    // Infinite scroll items number.
    let infinitScrollItems = 1000
    
    // MARK: Input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let searchBarDidTap = PassthroughSubject<Void, Never>()
    let logoButtonDidTap = PassthroughSubject<Void, Never>()
    let messageButtonDidTap = PassthroughSubject<Void, Never>()
    let cartButtonDidTap = PassthroughSubject<Void, Never>()

    private let coordinator: HomeCoordinatorType
    private let themeRepository: ThemeRepositoryType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorType, themeRepository: ThemeRepositoryType) {
        self.coordinator = coordinator
        self.themeRepository = themeRepository

        bindViewStateEvents()
        bindUserInteractionEvents()
        bindTransitionEvents()
    }
    
    private func bindViewStateEvents() {
        viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<[HomeTheme], Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.themeRepository.getThemes(isLatest: true)
            }
            .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: { [weak self] themes in
                self?.themes.send(themes)
            })
            .store(in: &cancellables)
        
        themes
            .map { [weak self] themes -> Int in
                guard let self = self, themes.count > 0 else { return 0 }

                return (self.infinitScrollItems / 2) - (self.infinitScrollItems / 2 % themes.count)
            }
            .sink(receiveValue: { [weak self] index in
                self?.firstHeaderIndex.send(index)
            })
            .store(in: &cancellables)
        
        viewDidAppear.prefix(1)
            .combineLatest(firstHeaderIndex)
            .map { _ ,firstHeaderIndexPath -> Int in
                firstHeaderIndexPath + 1
            }
            .sink(receiveValue: { [weak self] index in
                self?.hightLightHeaderIndex.send(index)
            })
            .store(in: &cancellables)
        
        viewDidAppear
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.presentNotificationPermissionDailog() { _ in }
            })
            .store(in: &cancellables)
    }
    
    private func bindUserInteractionEvents() {
        searchBarDidTap
            .print("searchBarDidTap")
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.requestSearchNavigation()
            })
            .store(in: &cancellables)
        
        logoButtonDidTap
            .print("logoButtonDidTap")
            .sink(receiveValue: { [weak self] _ in
                // TODO: implement.
            })
            .store(in: &cancellables)
        
        messageButtonDidTap
            .print("messageButtonDidTap")
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.requestMessageNavigation()
            })
            .store(in: &cancellables)
        
        cartButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.requestCartNavigation()
            })
            .store(in: &cancellables)
    }
    
    private func bindTransitionEvents() {
        coordinator.navigate
            .sink { _ in
                print("something went wrong in navigate")
            } receiveValue: { [weak self] in
                self?.navigationPath.append($0)
            }
            .store(in: &cancellables)
    }
}
