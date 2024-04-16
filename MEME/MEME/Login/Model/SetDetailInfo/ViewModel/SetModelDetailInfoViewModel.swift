//
//  SetModelDetailInfoViewModel.swift
//  MEME
//
//  Created by 이동현 on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SetModelDetailInfoViewModel: ViewModel {
    enum NavigationType {
        case fail
        case success
        case none
    }
    
    struct Input {
        let cellTap: Observable<IndexPath>
        let completeTap: Observable<Void>
    }
    struct Output{
        let cellModels: Observable<[[ModelDetailCellModel]]>
        let nextButtonState: Observable<Bool>
        var navigation: Observable<NavigationType>
    }
    
    private var genderCellModels = BehaviorRelay<[ModelDetailCellModel]>(value: [])
    private var skinCellModels = BehaviorRelay<[ModelDetailCellModel]>(value: [])
    private var colorCellModels = BehaviorRelay<[ModelDetailCellModel]>(value: [])
    private var gender = BehaviorRelay<Gender?>(value: nil)
    private var skinType = BehaviorRelay<SkinType?>(value: nil)
    private var personalColor = BehaviorRelay<PersonalColor?>(value: nil)
    private var navigation = PublishSubject<NavigationType>()
    private var disposeBag = DisposeBag()
    private var profileInfo: ProfileInfo
    private let authManager = AuthManager.shared
    
    init(profileInfo: ProfileInfo) {
        self.profileInfo = profileInfo
        makeCellModels()
    }

    func transform(_ input: Input) -> Output {
        input.cellTap
            .subscribe { [weak self] indexPath in
                self?.cellTapped(indexPath)
            }
            .disposed(by: disposeBag)
        
        input.completeTap
            .subscribe { [weak self] _ in
                print(self?.profileInfo)
                // TODO: - 서버 열리면 주석 해제
//                Task {
//                    let result = await self?.modelSignUp()
//                    if
//                        let result,
//                        result
//                    {
//                        self?.navigation.onNext(.success)
//                    } else {
//                        self?.navigation.onNext(.fail)
//                    }
//                }
                self?.navigation.onNext(.success)
            }
            .disposed(by: disposeBag)
        
        let cellModels = Observable.combineLatest(
            genderCellModels,
            skinCellModels,
            colorCellModels) { gender, skin, color -> [[ModelDetailCellModel]] in
            return [gender, skin, color]
        }
        
        let nextButtonIsEnable = Observable.combineLatest(
            gender.asObservable(),
            skinType.asObservable(),
            personalColor.asObservable())
            .map { gender, skinType, personalColor in
                return gender != nil && skinType != nil && personalColor != nil
            }
            .distinctUntilChanged()
        
        return Output(
            cellModels: cellModels,
            nextButtonState: nextButtonIsEnable,
            navigation: navigation.asObservable())
    }
}

// MARK: - action
extension SetModelDetailInfoViewModel {
    private func cellTapped(_ indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        let setSelected = { (cellModels: [ModelDetailCellModel]) in
            var newCellModels = cellModels
            
            newCellModels.indices.forEach { index in
                newCellModels[index].isSelected = false
            }
            newCellModels[row].isSelected = true
            return newCellModels
        }
        
        switch section {
        case ModelDetailInfoSection.gender.rawValue:
            Gender.allCases.forEach { gender in
                if gender.korString == genderCellModels.value[row].title {
                    profileInfo.gender = gender.rawValue
                    self.gender.accept(gender)
                }
            }
            genderCellModels.accept(setSelected(genderCellModels.value))
        case ModelDetailInfoSection.skin.rawValue:
            SkinType.allCases.forEach { skinType in
                if skinType.korString == skinCellModels.value[row].title {
                    profileInfo.skinType = skinType.rawValue
                    self.skinType.accept(skinType)
                }
            }
            skinCellModels.accept(setSelected(skinCellModels.value))
        default:
            PersonalColor.allCases.forEach { color in
                if color.korString == colorCellModels.value[row].title {
                    profileInfo.personalColor = color.rawValue
                    self.personalColor.accept(color)
                }
            }
            colorCellModels.accept(setSelected(colorCellModels.value))
        }
    }
    
    private func modelSignUp() async -> Bool {
        let result = await authManager.modelSignUp(profileInfo: profileInfo)
        
        switch result {
        case .success(let result):
            let userData = result.data
            let userId = userData.userId
            let accessToken = userData.accessToken
            let refreshToken = userData.refreshToken
            KeyChainManager.save(forKey: .memberId, value: "\(userId)")
            KeyChainManager.save(forKey: .accessToken, value: accessToken)
            KeyChainManager.save(forKey: .refreshToken, value: refreshToken)
            KeyChainManager.save(forKey: .nickName, value: profileInfo.nickname)
            KeyChainManager.save(forKey: .role, value: RoleType.MODEL.rawValue)
            return true
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
}

extension SetModelDetailInfoViewModel {
    private func makeCellModels() {
        var genderCellModels: [ModelDetailCellModel] = []
        Gender.allCases.forEach { gender in
            let cellModel = ModelDetailCellModel(title: gender.korString, isSelected: false)
            genderCellModels.append(cellModel)
        }
        
        var skinCellModels: [ModelDetailCellModel] = []
        SkinType.allCases.forEach { skin in
            let cellModel = ModelDetailCellModel(title: skin.korString, isSelected: false)
            skinCellModels.append(cellModel)
        }
        
        var colorCellModels: [ModelDetailCellModel] = []
        PersonalColor.allCases.forEach { color in
            let cellModel = ModelDetailCellModel(title: color.korString, isSelected: false)
            colorCellModels.append(cellModel)
        }
        
        self.genderCellModels.accept(genderCellModels)
        self.skinCellModels.accept(skinCellModels)
        self.colorCellModels.accept(colorCellModels)
    }
}
