//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // MARK: Output
    @Published var firstHeaderIndexPath: IndexPath = .init(item: 0, section: 0)
    @Published var hightLightHeaderIndexPath: IndexPath = .init(item: 1, section: 0)
    @Published var subjects: [String] = ["Explore", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ"]

    // MARK: Input
    let viewWillAppear = PassthroughSubject<Int, Error>()
    let viewDidAppear = PassthroughSubject<Void, Error>()

    private let coordinator: HomeCoordinatorType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorType) {
        self.coordinator = coordinator
        
        bindEvents()
    }
    
    private func bindEvents() {
        viewWillAppear
            .compactMap { [weak self] infinitScrollItems -> IndexPath? in
                guard let self = self else { return nil }
                
                let firstHeaderIndexPath = (infinitScrollItems / 2) - (infinitScrollItems / 2 % self.subjects.count)
                return IndexPath(item: firstHeaderIndexPath, section: 0)
            }
            .sink { _ in
                print("something went wrong in viewWillAppear")
            } receiveValue: { [weak self] indexPath in
                self?.firstHeaderIndexPath = indexPath
            }
            .store(in: &cancellables)
        
        viewDidAppear
            .compactMap { [weak self] in
                guard let firstHeaderIndexPath = self?.firstHeaderIndexPath else { return nil }
                return IndexPath(item: firstHeaderIndexPath.item + 1, section: firstHeaderIndexPath.section)
            }
            .sink { _ in
                print("something went wrong in viewDidAppear")
            } receiveValue: { [weak self] indexPath in
                self?.hightLightHeaderIndexPath = indexPath
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
