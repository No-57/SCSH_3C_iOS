//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var subjects: [String] = ["AAA", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ"]
    @Published var indexPath: IndexPath = .init(item: 0, section: 0)

    // MARK: Input
    let viewDidAppear = PassthroughSubject<Int, Error>()

    private let coordinator: HomeCoordinatorType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorType) {
        self.coordinator = coordinator
        
        bindEvents()
    }
    
    private func bindEvents() {
        viewDidAppear
            .compactMap { [weak self] infinitScrollItems -> IndexPath? in
                guard let self = self else { return nil }
                
                let firstItem = (infinitScrollItems / 2) - (infinitScrollItems / 2 % self.subjects.count)
                return IndexPath(item: firstItem, section: 0)
            }
            .sink { _ in
                print("something went wrong in viewDidAppear")
            } receiveValue: { [weak self] indexPath in
                self?.indexPath = indexPath
            }
            .store(in: &cancellables)
        
        viewDidAppear
            .sink { _ in
                print("something went wrong in viewDidAppear")
            } receiveValue: { [weak self] _ in
                self?.coordinator.presentNotificationPermissionDailog() { _ in }
            }
            .store(in: &cancellables)
    }
}
