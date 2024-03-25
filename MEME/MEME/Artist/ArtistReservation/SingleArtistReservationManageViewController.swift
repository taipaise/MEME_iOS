//
//  ArtistReservationSingleManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class SingleArtistReservationManageViewController: UIViewController {
    
    
    @IBOutlet var cancelBarView: UIView!
    @IBOutlet var cancelBarLabel: UILabel!
    @IBOutlet var cancelBarButton: UIButton!
    @IBOutlet var resInfoFrameView: UIView!
    
    private var isToday: Bool = false
    var reservationData: ReservationData!
    var modelData: ModelProfileInfoData!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getModelData(modelId: 5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        // Do any additional setup after loading the view.
    }

    private func uiSet(){
        self.navigationController?.isNavigationBarHidden = true
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
    }
    
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
            switch result {
            case .success(let response):
                print("모델 정보 조회 성공: \(response)")
                self.modelData = response.data
            case .failure(let error):
                print("모델 정보 조회 실패: \(error.localizedDescription)")
            }
        }
    }
}

