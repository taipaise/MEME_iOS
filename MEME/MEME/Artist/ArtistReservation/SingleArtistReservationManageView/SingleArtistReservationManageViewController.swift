//
//  ArtistReservationSingleManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class SingleArtistReservationManageViewController: UIViewController {
    //MARK: - UI Properties
    @IBOutlet weak var cancelBarView: UIView!
    @IBOutlet weak var cancelBarLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIButton!
    @IBOutlet weak var resInfoFrameView: UIView!
    @IBOutlet weak var modelNicknameLabel: UILabel!
    @IBOutlet weak var modelSkinTypeLabel: UILabel!
    @IBOutlet weak var modelGenderLabel: UILabel!
    @IBOutlet weak var modelPersonalColorLabel: UILabel!
    @IBOutlet weak var makeupNameLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationPlaceLabel: UILabel!
    
    //MARK: - Properties
    var isToday: Bool = false
    var reservationData: ReservationData!
    var modelData: ModelProfileInfoData!
    var reservationDateString: String!
    var reservationTimeString: String!
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getModelData(modelId: 1)
    }
    
    //MARK: - setUI()
    private func setUI(){
        self.tabBarController?.tabBar.isHidden = true
        cancelBarView.layer.cornerRadius=10
        resInfoFrameView.layer.cornerRadius=10
        if isToday {
            cancelBarView.backgroundColor = .gray500
            cancelBarLabel.text = "당일 예약은 취소가 불가능합니다"
            cancelBarButton.isHidden = true
        }else{
            cancelBarView.backgroundColor = .systemRed
            cancelBarLabel.text = "예약 취소하기"
            cancelBarButton.isHidden = false
        }
        if let data = modelData {
            //        modelProfileImageView.image = 이미지처리
            modelNicknameLabel.text = data.nickname
            modelGenderLabel.text = data.gender.korString
            modelSkinTypeLabel.text = data.skinType.korString
            modelPersonalColorLabel.text = data.personalColor.korString
        }
        makeupNameLabel.text = reservationData.makeupName
        reservationDateLabel.text = reservationDateString+" "+reservationTimeString+"시"
        reservationPlaceLabel.text = reservationData.shopLocation
    }
    //MARK: - @IBAction
    @IBAction private func backBtnDidTap(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func reservationCancelBtnDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "예약 취소하기", message: "\n예약을 취소하시겠습니까? 취소 시 모델에게 취소 알림이 전송됩니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.patchReservation(reservationId: self?.reservationData.reservationId ?? 0)
            if let navigationController = self?.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - API 호출
extension SingleArtistReservationManageViewController {
    func patchReservation(reservationId: Int) {
        ReservationManager.shared.patchReservation(
            reservationId: reservationId,
            status: .CANCEL
            ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("예약 상태 변경 성공: \(response)")
                case .failure(let error):
                    print("예약 상태 변경 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    func getModelData(modelId: Int) {
        let getModelData = ModelProfileInfoManager.shared
        getModelData.getModelProfileInfo(userId: modelId) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    print("모델 정보 조회 성공: \(response)")
                    self.modelData = response.data
                    self.setUI()
                case .failure(let error):
                    print("모델 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

