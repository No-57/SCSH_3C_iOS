//
//  ExploreViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import Foundation
import Combine

class ExploreViewModel: ObservableObject {
    // Output
    @Published var themes: [ExploreTheme] = [.Board]
    
    // First display index at board collection view.
    @Published var firstBoardSectionIndex: Int = 0
    @Published var boardSectionIsActive = false
    @Published var boards: [ExploreBoard] = []

    @Published var route = Route.none

    // Infinite scroll items number on Board section.
    let infiniteScrollItems = 1000

    // Input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let viewWillAppear = PassthroughSubject<Void, Never>()
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let viewWillDisappear = PassthroughSubject<Void, Never>()
    let boardCellDidTap = PassthroughSubject<ExploreBoard, Never>()
    
    private let coordinator: ExploreCoordinatorType
    private let boardRepository: BoardRepositoryType
    private let themeRepository: ThemeRepositoryType
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: ExploreCoordinatorType, boardRepository: BoardRepositoryType, themeRepository: ThemeRepositoryType) {
        self.coordinator = coordinator
        self.boardRepository = boardRepository
        self.themeRepository = themeRepository
        
        bindExploreEvents()
        bindBoardEvents()
        bindTransitionEvents()
    }

    private func bindExploreEvents() {
        viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<([ExploreTheme], [ExploreBoard]), Error> in
                guard let self = self else {
                    return Empty<([ExploreTheme], [ExploreBoard]), Error>().eraseToAnyPublisher()
                }
                
                return self.themeRepository.getExploreThemes(isLatest: false)
                    .combineLatest(self.boardRepository.getExploreBoards(isLatest: false))
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: { [weak self] (themes, boards) in
                self?.themes = themes
                self?.boards = boards
            })
            .store(in: &cancellables)
    }
    
    private func bindBoardEvents() {
        viewWillAppear
            .map { true }
            .assign(to: \.boardSectionIsActive, on: self)
            .store(in: &cancellables)
        
        viewWillDisappear
            .map { false }
            .assign(to: \.boardSectionIsActive, on: self)
            .store(in: &cancellables)
        
        $boards.dropFirst()
            .map { [weak self] boards -> Int in
                guard let self = self, boards.count > 0 else {
                    return 0
                }

                return (self.infiniteScrollItems / 2) - ((self.infiniteScrollItems / 2) % boards.count)
            }
            .assign(to: \.firstBoardSectionIndex, on: self)
            .store(in: &cancellables)
        
        boardCellDidTap
            .compactMap(\.action)
            .sink(receiveValue: { [weak self] in
                self?.coordinator.requestWebNavigation(url: $0)
            })
            .store(in: &cancellables)
    }

    private func bindTransitionEvents() {
        coordinator.navigate
            .assign(to: \.route, on: self)
            .store(in: &cancellables)
    }
}
